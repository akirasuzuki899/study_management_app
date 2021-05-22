module Api
  module V1
    class TaskSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :study_material_id, :name, :start, :end, :start_date, :end_date, :start_time, :end_time
    
      belongs_to :user
      belongs_to :study_material

      def start_date
        I18n.l(object.start_at, format: :date)
      end

      def end_date
        I18n.l(object.end_at, format: :date)
      end

      def start_time
        I18n.l object.start_at
      end

      def end_time
        I18n.l object.end_at
      end
    
      def start
        I18n.l(object.start_at, format: :dateTime)
      end
    
      def end
        I18n.l(object.end_at, format: :dateTime)
      end
    end

  end
end
