class TaskTemplate < ApplicationRecord
  include TaskBase
  include Rails.application.routes.url_helpers
  
  belongs_to :user
  belongs_to :study_material
  
  before_validation :set_start_date
  validates :user_id, presence: true
  validates :study_material_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :day_of_week, presence: true, inclusion: {in: %w(月 火 水 木 金 土 日)}
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :time_should_be_more_than_15min
  # validate :sunday_task_should_be_end_by_midnight

  BASEWEEK = { 
    "月" => "2000-01-03" , 
    "火" => "2000-01-04" , 
    "水" => "2000-01-05" , 
    "木" => "2000-01-06" , 
    "金" => "2000-01-07" , 
    "土" => "2000-01-08" , 
    "日" => "2000-01-09" , 
  }

  # def sunday_task_should_be_end_by_midnight
  #   return if self.start_time.nil? || self.end_time.nil?
  #   errors.add(:total_time, "日曜日の予定は当日の範囲で選択してください") if self.day_of_week == "日" && until_tomorrow?
  # end

  def set_start_date
    self.start_date = BASEWEEK[day_of_week]
  end

end