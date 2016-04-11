require_dependency "ournaropa_planner/application_controller"

module OurnaropaPlanner
  class ScraperController < ApplicationController

    # inherit the layout from the main application
    layout 'application'      
    
    # Require the gems
    require 'capybara/poltergeist'    
    
    rescue_from ::Capybara::Poltergeist::TimeoutError, with: :restart_operations
    rescue_from Capybara::ElementNotFound, with: :restart_operations
    
    def scrape
      
      puts "Scraping process initiated..."
      
      # determines if we're doing a surface fetch or a full fetch of description, books, etc ...
      @do_full_fetch = params[:full_fetch] == "true" || false
      
      puts (@do_full_fetch ? "Full" : "Quick") + " fetch requested."
      
      @num_classes_scraped = params[:courses_scraped].to_i || 0
        
      puts "Starting with course nr #{@num_classes_scraped+1}. Lock'n'load."
      
      scrape_my_naropa
            
      #course_count = get_courses.count
      
      
      
      #@browser.save_and_open_page
      
      #binding.pry
      
      # create courses
      
    end
    
    private
    
    # scrapes classes starting from x position and doing a full or fast fetch
    def scrape_my_naropa
      
      # initiate browser
      @browser = get_browser
      
      # go to myNaropa
      @browser.visit "https://my.naropa.edu/ics"

      # sign in
      sign_in unless is_signed_in?

      # cancel operations unless user is signed in
      raise "Error: Logging in unsuccessful" unless is_signed_in?

      # navigate to Student tab
      @browser.within("#headerTabs") do
        @browser.click_link("Student")
      end

      # navigate to register for classes
      @browser.click_link("Register for Classes")

      # navigate to course search
      @browser.click_link("Course Search")

      # select Fall 2016 classes and start search
      @browser.within("#PORTLETGRID") do
        @browser.select "FA 2016", :from => "Term"
      end

      sleep 2 # give phantomjs 2 seconds and let the page fill itself in

      # start search
      @browser.within("#PORTLETGRID") do
        puts "Initiating Search"
        @browser.click_button "Search"
      end
      
      sleep 2 # give phantomjs 2 seconds and let the page fill itself in

      # show all courses
      @browser.within("#PORTLETGRID") do
        @browser.click_link("Show All", :match => :first)
      end

      total_num_courses = get_courses.count
      force_restart = false

      for @num_classes_scraped in @num_classes_scraped..total_num_courses-1 do  
        
        if force_restart
          puts "We've encountered a server error on MyNaropa. We'll be restarting our engines now..."
          redirect_to scrape_url+"?"+{full_fetch: @do_full_fetch, courses_scraped: @num_classes_scraped}.to_param
          break
        end
        
        # visit a course
        course = get_courses[@num_classes_scraped]

        # scrape data
        scraped_data = course.all('td')

        course_info = {}
        course_info[:code] = scraped_data[2].text
        course_info[:name] = scraped_data[3].text
        course_info[:instructor] = scraped_data[6].text
        course_info[:enrollment_current] = scraped_data[7].text.split("/")[0].to_i
        course_info[:enrollment_maximum] = scraped_data[7].text.split("/")[1].to_i
        course_info[:enrollment_waitlist] = scraped_data[8].text.split("/")[0].to_i
        course_info[:books] = []          
        
        # FULL FETCH METHODS
        if @do_full_fetch
          
          # scrape amount of credits
          course_info[:credits] = scraped_data[11].text.to_f
          
          # scrape times and scrape location
          course_info[:meeting_times] = []
          scraped_data[10].all("ul li").each do |time|

            meeting = {}

            meeting[:datetime] = time.text.split(";")[0].strip
            meeting[:location] = time.text.split(";")[1].strip

            course_info[:meeting_times].push(meeting)
          end

          # scrape start date and end date
          course_info[:start_date] = DateTime.strptime(scraped_data[12].text, "%m/%d/%Y")
          course_info[:end_date] =DateTime.strptime(scraped_data[13].text, "%m/%d/%Y")
          
          # check if we have books
          scrape_textbooks scraped_data, course_info, false
          

          # open course
          @browser.click_link(course.find('a').text)

          if @browser.has_no_css?("#PORTLETGRID") and @browser.has_text?("Server Error")
            force_restart = true
            course_info[:description] = "Sorry, scanning the course on myNaropa led to the following error:\n#{@browser.document.title}"
          else           
            # get course description
            course_info[:description] = @browser.find("#PORTLETGRID #pg0_V_lblCourseDescValue").text unless @browser.has_no_css?("#PORTLETGRID #pg0_V_lblCourseDescValue")

            # get course note
            course_info[:note] =  @browser.find("#PORTLETGRID #pg0_V_lblNotesValue").text unless @browser.has_no_css?("#PORTLETGRID #pg0_V_lblNotesValue")

            #binding.pry

            # open prerequisites
            if @browser.has_link?("Course Requisites")

              @browser.click_link("Course Requisites")

              @browser.within("#PORTLETGRID") do

                requirements = @browser.all("table#pg0_V_dgReq > tbody > tr:not(.alt)")

                course_info[:requirements] = ""

                requirements.each do |req|
                  # add a line break to course info to separate requirements
                  course_info[:requirements] += "\n" unless course_info[:requirements].blank?

                  course_info[:requirements] += req.all("td")[3].text
                end

                @browser.click_link("Course Details")
              end

            end
          
            # return to course search results
            @browser.within("#PORTLETGRID") do
              @browser.click_link("Back")
            end
            
          end

        end

        create_or_update_course(course_info)

        puts "Successfully scraped #{@num_classes_scraped+1} of #{total_num_courses}: #{course_info[:name]}"

      end
    end
    
    # scrapes textbooks and can close textbooks if needed
    def scrape_textbooks scraped_data, course_info, force_close
      if scraped_data[1].has_css?("img")

        # open books
        scraped_data[1].find("img").click

        books = @browser.all("#pg0_V_dgCourses > tbody > tr.subItem")[0].all("tbody.gbody > tr")

        for i in 0..books.count/2-1 do
          book = {:title => "", :author => "", :publisher => "", :copyright => "", :description => ""}

          bookMain = books[i*2]
          bookInfo = books[i*2+1]

          book[:title] = bookMain.all("td")[0].text

          # if we have book info, then fill it in
          if bookInfo.text.present?
            
            # get the author
            book[:author] = bookInfo.all("table tbody tr")[0].all("td")[0].text.sub("Author(s):", "").strip
            
            # get publisher (+copyright), if exists
            if bookInfo.all("table tbody tr").count > 1
              
              # if we have two tds in this row, we have copyright and then publisher
              if bookInfo.all("table tbody tr")[1].all("td").count == 2
                book[:copyright] = bookInfo.all("table tbody tr")[1].all("td")[0].text.sub("Copyright:", "").strip
                book[:publisher] = bookInfo.all("table tbody tr")[1].all("td")[1].text.sub("Publisher:", "").strip
              else #otherwise it's just publisher
                book[:publisher] = bookInfo.all("table tbody tr")[1].all("td")[0].text.sub("Publisher:", "").strip
              end
            end
            
            # get the description if one exists
            book[:description] = bookInfo.all("table tbody tr")[2].all("td")[0].text.sub("Description:", "").strip unless bookInfo.all("table tbody tr").count < 3
          end

          course_info[:books].push(book)
        end

        # close books
        scraped_data[1].find("img").click unless not force_close

      end
    end
    
    # creates or updates a course as passed by course params
    def create_or_update_course course

      # try to find an existing course with this code
      existing_course = Course.find_by code: course[:code]

      # if course exists, then let's update it
      if existing_course.present?
        existing_course.update(course)
      else #otherwise create new
        Course.create(course)
      end
      
    end
    
    def is_signed_in?
      return !@browser.has_css?("#userLogin")
    end
    
    def sign_in
      puts "Signing in..."
      @browser.within("#userLogin") do
        @browser.fill_in "userName", with: ENV["mynaropa_username"]
        @browser.fill_in "password", with: ENV["mynaropa_password"]
        @browser.click_on "Login"
      end
    end
    
    def get_courses
      return @browser.all("#pg0_V_dgCourses > tbody > tr:not(.subItem)")
    end
    
    def restart_operations exception
      #binding.pry
      
      puts "Encountered error: #{exception.message}"
      puts "But no worries! We'll be right back up..."
      puts "#{@num_classes_scraped} courses scraped so far. Restarting operations now..."
      
      redirect_to scrape_url+"?"+{full_fetch: @do_full_fetch, courses_scraped: @num_classes_scraped}.to_param
    end
    
  end
end
