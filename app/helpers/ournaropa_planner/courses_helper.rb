module OurnaropaPlanner
  module CoursesHelper
    def print_book book
      output = ""
      
      #title
      output += "<strong>" + h(book[:title]) + "</strong>"
      
      #author
      return output unless book[:author].present?
      output += " by <em>" + h(book[:author]) + "</em>"
      
      #open brakcets if publisher or copyright?
      output += " (" if book[:publisher].present? or book[:copyright].present?
      
      #publisher
      output += h(book[:publisher]) if book[:publisher].present?
      
      # add comma separator if both publisher and copyright will be shown
      output += ", " if book[:publisher].present? and book[:copyright].present?
      
      #copyright
      output += h(book[:copyright]) if book[:copyright].present?
      
      #close brackets if publisher or copyright?
      output += ")" if book[:publisher].present? or book[:copyright].present?
      
      
      #description
      output += "<br/>" + h(book[:description]) if book[:description].present?
      
      return output
    
    end
  end
end
