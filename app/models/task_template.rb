class TaskTemplate < ApplicationRecord
  include TaskBase
  include Rails.application.routes.url_helpers
  
  belongs_to :user
  belongs_to :study_material
  
  before_validation :set_start_day_of_week
  validates :user_id, presence: true
  validates :study_material_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :start_date, presence: true,
                         inclusion: {in: ("2000-01-03".to_date.."2000-01-09".to_date)}
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :time_should_be_more_than_15min

  BASEWEEK = {
    "月" => "2000-01-03", 
    "火" => "2000-01-04", 
    "水" => "2000-01-05", 
    "木" => "2000-01-06", 
    "金" => "2000-01-07", 
    "土" => "2000-01-08", 
    "日" => "2000-01-09", 
  }

  def set_start_day_of_week
    self.day_of_week = %w(日 月 火 水 木 金 土)[start_date.wday]
  end

end