class Task < ApplicationRecord
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
  # validate :start_should_be_before_end
  validate :start_should_be_after_now
  validate :time_should_be_more_than_15min
  validate :time_should_be_less_than_24h


  # def start_should_be_before_end
  #   return if self.start.nil? || self.end.nil?
  #   errors.add(:end, "終了日時は開始日時より遅い時間を選択してください") if self.start > self.end
  # end

  def start_should_be_after_now
    return if self.start.nil?
    errors.add(:start, "開始日時は現在の日時以降を選択してください") if self.start < Time.now
  end

  def time_should_be_more_than_15min
    return if self.start.nil? || self.end.nil?
    total_time_sec = self.end - self.start
    errors.add(:total_time, "合計時間は15分以上にしてください") if total_time_sec < 15*60
  end

  def time_should_be_less_than_24h
    return if self.start.nil? || self.end.nil?  
    total_time_sec = self.end - self.start
    errors.add(:total_time, "合計時間は24時間以内にしてください") if total_time_sec > 24*60*60
  end


  # private

  def until_midnight? 
    return if self.start_time.nil? || self.end_time.nil? 
    (I18n.localize self.end_time)  == "00:00" ? true : false
  end

  def until_tomorrow?
    return if self.start_time.nil? || self.end_time.nil?  
    !until_midnight? && self.start_time >= self.end_time ? true : false
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

  def start
    start_at = start_date.present? && start_time.present? ? [start_date, I18n.l(start_time)].join(" ") : nil
    start_at ? Time.parse(start_at) : nil
  end
  
  def end
    return unless start_date.present? && start_time.present? && end_time.present?
    end_date = until_tomorrow? ? start_date.tomorrow : start_date
    end_time = until_midnight? ? "24:00" : I18n.l(self.end_time)
    end_at = [end_date, end_time].join(" ")
    return Time.parse(end_at)
  end
end
