module Api
  module V1
    class TaskTemplateSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :study_material_id, :name, :day_of_week, :start_time, :end_time, :start, :end

      belongs_to :user
      belongs_to :study_material

      BASEWEEK = { 
        "月" => "2000-01-03" , 
        "火" => "2000-01-04" , 
        "水" => "2000-01-05" , 
        "木" => "2000-01-06" , 
        "金" => "2000-01-07" , 
        "土" => "2000-01-08" , 
        "日" => "2000-01-09" , 
      }

      def start_date
        BASEWEEK[object.day_of_week]
      end
    
      def start_time
        I18n.localize object.start_time
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
