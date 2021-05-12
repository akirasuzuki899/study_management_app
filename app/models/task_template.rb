class TaskTemplate < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :study_material
  
  BASEWEEK = { 
    "月" => "2000-01-03" , 
    "火" => "2000-01-04" , 
    "水" => "2000-01-05" , 
    "木" => "2000-01-06" , 
    "金" => "2000-01-07" , 
    "土" => "2000-01-08" , 
    "日" => "2000-01-09" , 
  }
  def start
    start_time = self.start_time.strftime('%H:%M:%S')
    return "#{BASEWEEK[day_of_week]} #{start_time}"
  end

  def end
    end_time = self.end_time.strftime('%H:%M:%S')
    return "#{BASEWEEK[day_of_week]} #{end_time}"
  end

  def start_time_hm
    start_time = self.start_time.strftime('%H:%M')
  end

  def end_time_hm
    end_time = self.end_time.strftime('%H:%M')
  end

end
