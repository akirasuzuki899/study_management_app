class Task < ApplicationRecord
  attr_accessor :start_date, :start_time, :end_date, :end_time
  before_validation :set_start_at, :set_end_at
  belongs_to :user
  belongs_to :study_material


  private

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

  def set_start_at
    self.start_at = start_date.present? && start_time.present? ? [start_date, start_time].join(" ") : nil
  end

  def set_end_at
    self.end_at = end_date.present? && end_time.present? ? [end_date, end_time].join(" ") : nil
  end
end
