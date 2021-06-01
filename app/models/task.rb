class Task < ApplicationRecord
  include TaskBase
  has_one :study_record, dependent: :destroy
  belongs_to :user
  belongs_to :study_material

  validates :user_id, presence: true
  validates :study_material_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  # VALID_DATE_REGEX = /\A(20[0-9]{2})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])\z/  # 2000-01-01
  # VALID_TIME_REGEX = /\A([01][0-9]|2[0-4]):[0-5][0-9]\z/                          # 00:00
  validates :start_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :start_should_be_after_now
  validate :time_should_be_more_than_15min


  def start_should_be_after_now
    return if start_at.nil?
    errors.add(:start, "開始日時は現在の日時以降を選択してください") if start_at < Time.now
  end

  def self.set_next_week_date
    today = Time.now
    next_week = { 
      "月" => I18n.l( today.next_week(:monday), format: :date ) , 
      "火" => I18n.l( today.next_week(:tuesday), format: :date )  , 
      "水" => I18n.l( today.next_week(:wednesday), format: :date )  , 
      "木" => I18n.l( today.next_week(:thursday), format: :date )  , 
      "金" => I18n.l( today.next_week(:friday), format: :date )  , 
      "土" => I18n.l( today.next_week(:saturday), format: :date )  , 
      "日" => I18n.l( today.next_week(:sunday), format: :date )  , 
    } 
  end

  def self.create_next_week_tasks_by_task_templates
    next_week = Task.set_next_week_date
    users = User.joins(:task_templates).group("users.id")

    users.each do | user |
      task_templates = user.task_templates
      tasks = []
      now = Time.current
      
      task_templates.each do | task_template |
        task = {
          user_id: task_template.user_id,
          study_material_id: task_template.study_material_id,
          name: task_template.name,
          start_at: "`#{next_week[task_template.day_of_week]} #{task_template.start_time}`",
          end_at: "`#{next_week[task_template.day_of_week]} #{task_template.end_time}`",
          created_at: now,
          updated_at: now
        }
        tasks << task
      end
      Task.insert_all(tasks)
    end
  end
end
