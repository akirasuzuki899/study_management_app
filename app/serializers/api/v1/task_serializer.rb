module Api
  module V1
    class TaskSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :study_material_id, :name, :start, :end, :start_date, :end_date, :start_time, :end_time
    
      belongs_to :user
      belongs_to :study_material

      def start_date
        I18n.l(object.start_date, format: :date)
      end
            
      def start_time
        I18n.l object.start_time
      end

      def end_date
        object.until_tomorrow? ? I18n.l(Time.parse(start_date).tomorrow, format: :date) : start_date
      end

      def end_time
        object.until_midnight? ? "24:00" : (I18n.localize object.end_time)
      end
    
      def start
        "#{start_date} #{start_time}"
      end
    
      def end
        "#{end_date} #{end_time}"
      end

    end
  end
end
