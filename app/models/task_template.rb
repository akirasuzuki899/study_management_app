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

  # validate :start_time_should_be_before_end_time
  # validate :time_shoud_be_less_than24h
  # validates :time_shoud_be_more_than15m

  # def start_time_should_be_before_end_time 
  #   if self.is_until_tomorrow == false && self.start_time > self.end_time then
  #     errors.add(:end_time, "は開始時刻より遅い時間を選択してください")
  #   end
  # end

  # def time_shoud_be_less_than24h
  #     errors.add(:total_time, "合計時間は24時間以内にしてください") if self.start_time == self.end_time
  # end

  def time_shoud_be_more_than_15min
    if until_tomorrow? then 
      day_sec = 86400
      errors.add(:total_time, "合計時間は24時間以内にしてください") if day_sec - self.start_time + self.end_time > 15*60
    end
      total_time_sec = self.end_time - self.start_time
      errors.add(:total_time, "合計時間は24時間以内にしてください") if total_time_sec < 15*60
  end

  def until_tomorrow?
    self.start_time > self.end_time ? true : false
  end
end
