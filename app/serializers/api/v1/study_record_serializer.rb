module Api
  module V1
    class StudyRecordSerializer < ActiveModel::Serializer

      attributes :id, :user_id, :study_material_id, :task_id, :start, :end, :start_date, :start_time, :end_date, :end_time, :is_finished

      def start_date
        return if object.start_date.nil?
        I18n.l(object.start_date, format: :date)
      end

      def start_time
        return if object.start_time.nil?
        I18n.l object.start_time
      end
      
      def end_date
        return if object.start_date.nil?
        object.until_tomorrow? ? I18n.l(Time.parse(start_date).tomorrow, format: :date) : start_date
      end

      def end_time
        return if object.end_time.nil?
        object.until_midnight? ? "24:00" : (I18n.l object.end_time)
      end

      def start
        return if object.start_date.nil?
        "#{start_date} #{start_time}"
      end

      def end
        return if end_date.nil?
        "#{end_date} #{end_time}"
      end

    end
  end
end