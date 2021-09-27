class StudyRecord < ApplicationRecord
  include TaskBase
  belongs_to :user
  belongs_to :task
  belongs_to :study_material

  validates :user_id, presence: true
  validates :task_id, presence: true
  validates :study_material_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

end
