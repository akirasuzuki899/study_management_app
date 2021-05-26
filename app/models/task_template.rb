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

  validate :time_shoud_be_more_than_15min

  def time_shoud_be_more_than_15min
    return if self.start_time.nil? || self.end_time.nil?  # start_time,end_timeの値が無い時、処理を中断する(エラーになるのを防ぐ)

    if until_tomorrow? || until_midnight? then 
      # total_time_sec = self.end_time.tomorrow - self.start_time
      # errors.add(:total_time, "合計時間は15分以上にしてください") if total_time_sec < 15*60
      total_time_sec = self.end_time.tomorrow - self.start_time
      errors.add(:total_time, "合計時間は15分以上にしてください") if total_time_sec < 15*60
      logger.info "-----------------time_shoud_be_more_than_15min method until_tomorrow? or until_midnight? : true-----------------"
    else
      total_time_sec = self.end_time - self.start_time
      errors.add(:total_time, "合計時間は15分以上にしてください") if total_time_sec < 15*60
      logger.info "-----------------time_shoud_be_more_than_15min method 今日中かつ23:45まで : true-----------------"
    end
  end

  def until_midnight?
    return if self.start_time.nil? || self.end_time.nil? # start_time,end_timeの値が無い時、処理を中断する(エラーになるのを防ぐ)
    # (I18n.localize self.end_time)  == "00:00" ? true : false
    tmp = (I18n.localize self.end_time)  == "00:00" ? true : false
    logger.info "-----------------until_midnight? method : #{tmp}-----------------"
    return tmp
  end

  def until_tomorrow?
    return if self.start_time.nil? || self.end_time.nil?  # start_time,end_timeの値が無い時、処理を中断する(エラーになるのを防ぐ)
      # self.start_time >= self.end_time ? true : false
      tmp =  !until_midnight? && self.start_time >= self.end_time ? true : false
      logger.info "-----------------until_tomorrow? method : #{tmp}-----------------"
    return tmp
  end
end
