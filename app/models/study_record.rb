class StudyRecord < ApplicationRecord
  belongs_to :user
  belongs_to :task
  belongs_to :study_material

  validates :user_id, presence: true
  validates :task_id, presence: true
  validates :study_material_id, presence: true
  validates :start_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  def until_midnight? 
    return if start_time.nil? || end_time.nil? 
    (I18n.l end_time)  == "00:00" ? true : false
  end

  def until_tomorrow?
    return if start_time.nil? || end_time.nil?  
    !until_midnight? && start_time >= end_time ? true : false
  end
  
end
