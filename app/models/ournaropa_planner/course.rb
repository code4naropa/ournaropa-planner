module OurnaropaPlanner
  class Course < ActiveRecord::Base
    
    searchkick highlight: [:name, :description, :instructor, :code], word_middle: [:name, :description, :instructor, :code]
    
    serialize(:books, Array)
    serialize(:meeting_times, Array)
    
    validates_presence_of :name, :code
    validates_uniqueness_of :code
    
    
    def meeting_datetime
      return self.meeting_times[0][:datetime] if self.meeting_times.count == 1
      
      return "Various"
    end
    
    def meeting_location
      return self.meeting_times[0][:location] if self.meeting_times.count == 1
      
      return "Various"
    end
    
    def enrollment_status
      
      status = ""
      
      if self.enrollment_current.present?
        status += self.enrollment_current.to_s
      else
        status += "?"
      end
      
      status += "/"

      if self.enrollment_maximum.present?
        status += self.enrollment_maximum.to_s
      else
        status += "?"
      end
      
      if self.enrollment_waitlist.present?
        status += " + " + self.enrollment_waitlist.to_s unless self.enrollment_waitlist == 0
      else
        status += " + ?"
      end
      
      return status
    end
    
  end
end
