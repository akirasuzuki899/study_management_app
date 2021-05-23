class TaskTemplate < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :study_material

  validates :user_id, presence: true
  validates :study_material_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :day_of_week, presence: true
  VALID_TIME_REGEX = /\A([01][0-9]|2[0-3]):[0-5][0-9]\z/   # 00:00
  validates :start_time, presence: true, format: { with: VALID_TIME_REGEX, message: "hh:mm" }
  validates :end_time, presence: true, format: { with: VALID_TIME_REGEX, message: "hh:mm" }
  validates :is_until_tomorrow, inclusion: {in: [true, false]}
end
