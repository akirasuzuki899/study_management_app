module TaskBase
  extend ActiveSupport::Concern

  # def time_should_be_less_than_24h
  #   return if start_at.nil? || end_at.nil?  
  #   total_time_sec = end_at - start_at
  #   errors.add(:total_time, "合計時間は24時間以内にしてください") if total_time_sec > 24*60*60
  # end

  def time_should_be_more_than_15min
    return if start_at.nil? || end_at.nil?
    total_time_sec = end_at - start_at
    errors.add(:total_time, "合計時間は15分以上にしてください") if total_time_sec < 15*60
  end

  #vueから送信された時点では24:00だが、オブジェクトに値を代入すると00:00に変換される
  #railsではend_timeに限って24:00を00:00として扱う
  # def until_midnight? 
  #   return if start_time.nil? || end_time.nil? 
  #   (I18n.l end_time)  == "00:00" ? true : false
  # end

  # 終了時刻 <= 開始時刻の時、日をまたぐ
  def until_tomorrow?
    return if start_time.nil? || end_time.nil?  
    start_time >= end_time ? true : false
  end

  def start_at
    start_at = start_date.present? && start_time.present? ? [start_date, I18n.l(start_time)].join(" ") : nil
    start_at ? Time.parse(start_at) : nil
  end
  
  def end_at
    return unless start_date.present? && start_time.present? && end_time.present?
    end_date = until_tomorrow? ? start_date.tomorrow : start_date
    end_at = [end_date, end_time].join(" ")
    return Time.parse(end_at)
  end
end