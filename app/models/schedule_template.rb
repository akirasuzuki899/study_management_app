class ScheduleTemplate < ApplicationRecord
  belongs_to :user
  belongs_to :study_material
  
  BASEWEEK = { 
    月: "2000-01-03" , 
    火: "2000-01-04" , 
    水: "2000-01-05" , 
    木: "2000-01-06" , 
    金: "2000-01-07" , 
    土: "2000-01-08" , 
    日: "2000-01-09" , 
  }
  def start
    start_time = self.start_time.strftime('%H:%M:%S')
    # return BASEWEEK[:月] + " " + start_time
    return "#{BASEWEEK[:月]} #{start_time}"
  end

  def end
    end_time = self.end_time.strftime('%H:%M:%S')
    return "#{BASEWEEK[:月]} #{end_time}"
  end
end
