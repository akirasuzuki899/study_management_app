class Task < ApplicationRecord
  include TaskBase
  has_one :study_record, dependent: :destroy
  belongs_to :user
  belongs_to :study_material

  before_validation :set_end_date
  after_create :create_study_record

  validates :user_id, presence: true
  validates :study_material_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  # VALID_DATE_REGEX = /\A(20[0-9]{2})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])\z/  # 2000-01-01
  # VALID_TIME_REGEX = /\A([01][0-9]|2[0-4]):[0-5][0-9]\z/                          # 00:00
  validates :start_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :time_should_be_more_than_15min

  def self.week_date(after_num_weeks)
    today = Date.today
    if after_num_weeks == 0
      monday = today.beginning_of_week
    else
      num = after_num_weeks
      monday = (today + num.week).beginning_of_week
    end

    week = {
      "月" => I18n.l( monday, format: :date ),
      "火" => I18n.l( monday + 1, format: :date ),
      "水" => I18n.l( monday + 2, format: :date ),
      "木" => I18n.l( monday + 3, format: :date ),
      "金" => I18n.l( monday + 4, format: :date ),
      "土" => I18n.l( monday + 5, format: :date ),
      "日" => I18n.l( monday + 6, format: :date ),
    }
  end

  def set_end_date
    if until_tomorrow?
      self.end_date = self.start_date + 1
    else 
      self.end_date = self.start_date
    end
  end

  # def system_create_tasks_from_task_templates(task_templates)
  #   week = Task.set_next_week_date
  #   users = User.joins(:task_templates).group("users.id")

  #   users.each do | user |
  #     task_templates = user.task_templates
  #     now = Time.current
  #     create_tasks_from_tesk_templates(task_templates)
  #   end
  # end


  def self.create_tasks_from_templates(templates: task_templates, after_num_weeks: num)
    week = Task.week_date(after_num_weeks)
    now = Time.current
    tasks = []
    templates.each do | template |
      task = {
        user_id: template.user_id,
        study_material_id: template.study_material_id,
        name: template.name,
        start_date: week[template.day_of_week],
        start_time: template.start_time,
        end_time: template.end_time,
        color: template.color,
        created_at: now,
        updated_at: now
      }
      tasks << task
    end
      Task.create!(tasks)
  end

  def create_study_record
    study_record = set_study_record()
    study_record.save(validate: false)
  end

  def set_study_record
    StudyRecord.new(
      user_id: self.user_id,
      task_id: self.id,
      study_material_id: self.study_material_id,
    )
  end

end
