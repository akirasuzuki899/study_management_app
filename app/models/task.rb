class Task < ApplicationRecord
  attr_accessor :start_date, :start_time, :end_date, :end_time
  belongs_to :user
  belongs_to :study_material
  
  before_validation :set_start_at, :set_end_at
  validates :user_id, presence: true
  validates :study_material_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  VALID_DATE_REGEX = /\A(20[0-9]{2})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])\z/  # 2000-01-01
  VALID_TIME_REGEX = /\A([01][0-9]|2[0-3]):[0-5][0-9]\z/                          # 00:00
  validates :start_date, presence: true, format: { with: VALID_DATE_REGEX, message: "shoud be yyyy-mm-dd" }
  validates :end_date, presence: true, format: { with: VALID_DATE_REGEX, message: "shoud be yyyy-mm-dd" }
  validates :start_time, presence: true, format: { with: VALID_TIME_REGEX, message: "shoud be hh:mm" }
  validates :end_time, presence: true, format: { with: VALID_TIME_REGEX, message: "shoud be hh:mm" }
  validate :start_at_should_be_before_end_at
  validate :start_at_should_be_after_now

  def start_at_should_be_before_end_at
    return "aaa" if self.start_at.nil? || self.end_at.nil?  # start_time,end_timeの値が無い時、処理を中断する(エラーになるのを防ぐ)
    errors.add(:end_at, "終了日時は開始日時より遅い時間を選択してください") if self.start_at > self.end_at
  end

  def start_at_should_be_after_now
    return if self.start_at.nil?  # start_timeの値が無い時、処理を中断する(エラーになるのを防ぐ)
    errors.add(:start_at, "開始日時は現在の日時以降を選択してください") if self.start_at < Time.now
  end


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
