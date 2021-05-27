class TaskTemplate < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :study_material

  validates :user_id, presence: true
  validates :study_material_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :day_of_week, presence: true, inclusion: {in: %w(月 火 水 木 金 土 日)}
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :is_until_tomorrow, inclusion: {in: [true, false]}

  validate :time_should_be_more_than_15min
  validate :sunday_task_should_be_end_by_midnight

  def time_should_be_more_than_15min
    return if self.start_time.nil? || self.end_time.nil?  

    if until_tomorrow? || until_midnight? then 
      total_time_sec = self.end_time.tomorrow - self.start_time
      errors.add(:total_time, "合計時間は15分以上にしてください") if total_time_sec < 15*60
    else
      total_time_sec = self.end_time - self.start_time
      errors.add(:total_time, "合計時間は15分以上にしてください") if total_time_sec < 15*60
    end
  end

  def sunday_task_should_be_end_by_midnight 
    return if self.start_time.nil? || self.end_time.nil?
    errors.add(:total_time, "日曜日の予定は当日の範囲で選択してください") if self.day_of_week == "日" && until_tomorrow?
  end

  def until_midnight?
    return if self.start_time.nil? || self.end_time.nil? 
    (I18n.localize self.end_time)  == "00:00" ? true : false
  end

  def until_tomorrow?
    return if self.start_time.nil? || self.end_time.nil?  
    !until_midnight? && self.start_time >= self.end_time ? true : false
  end

end
