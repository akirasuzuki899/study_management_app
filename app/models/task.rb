class Task < ApplicationRecord
  include TaskBase
  has_one :study_record, dependent: :destroy
  belongs_to :user
  belongs_to :study_material

  before_validation :set_end_date

  validates :user_id, presence: true
  validates :study_material_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  # VALID_DATE_REGEX = /\A(20[0-9]{2})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])\z/  # 2000-01-01
  # VALID_TIME_REGEX = /\A([01][0-9]|2[0-4]):[0-5][0-9]\z/                          # 00:00
  validates :start_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :start_day_should_be_after_today
  validate :time_should_be_more_than_15min


  def start_day_should_be_after_today
    return if start_date.nil?
    errors.add(:start, "開始日時は現在の日時以降を選択してください") if start_date < Date.today
  end

  def self.set_next_week_date
    today = Date.today
    next_week_monday = (today + 1.week).beginning_of_week
    next_week = { 
      "月" => I18n.l( next_week_monday, format: :date ),
      "火" => I18n.l( next_week_monday + 1, format: :date ),
      "水" => I18n.l( next_week_monday + 2, format: :date ),
      "木" => I18n.l( next_week_monday + 3, format: :date ),
      "金" => I18n.l( next_week_monday + 4, format: :date ),
      "土" => I18n.l( next_week_monday + 5, format: :date ),
      "日" => I18n.l( next_week_monday + 6, format: :date ),
    } 
  end

  def self.set_this_week_date
    today = Date.today
    monday = today.beginning_of_week
    this_week = {
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

  # def system_create_next_week_tasks_from_task_templates(task_templates)
  #   next_week = Task.set_next_week_date
  #   users = User.joins(:task_templates).group("users.id")

  #   users.each do | user |
  #     task_templates = user.task_templates
  #     now = Time.current
  #     create_tasks_from_tesk_templates(task_templates)
  #   end
  # end


  def self.create_this_week_tasks_from_templates(task_templates)
    this_week = Task.set_this_week_date
    now = Time.current
    tasks = []
    task_templates.each do | task_template |
      task = {
        user_id: task_template.user_id,
        study_material_id: task_template.study_material_id,
        name: task_template.name,
        start_date: this_week[task_template.day_of_week],
        start_time: task_template.start_time,
        end_time: task_template.end_time,
        color: task_template.color,
        created_at: now,
        updated_at: now
      }
      tasks << task
    end
      Task.create!(tasks)
  end
end
