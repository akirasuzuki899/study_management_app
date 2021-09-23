module Api
  module V1
    class StudyRecordSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :study_material_id, :task_id, :start, :end, :is_finished

      def start
        object.start_time ? I18n.l(object.start_time, format: :dateTime) : nil
      end
      
      def end
        object.start_time ? I18n.l(object.end_time, format: :dateTime) : nil
      end
      
    end
  end
end