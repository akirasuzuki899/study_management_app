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
    
      def start_time
        # I18n.localize object.start_time
        tmp =  I18n.localize object.start_time
        Rails.logger.info "-----------------start_time method : #{tmp}-----------------"
        return tmp
      end

      def end_time
        # object.until_midnight? ? "24:00" : (I18n.localize object.end_time)
        tmp =  object.until_midnight? ? "24:00" : (I18n.localize object.end_time)
        Rails.logger.info "-----------------end_time method : #{tmp}-----------------"
        return tmp
      end

      def start
        # "#{BASEWEEK[object.day_of_week]} #{start_time}"
        tmp = "#{BASEWEEK[object.day_of_week]} #{start_time}"
        Rails.logger.info "-----------------start method : #{tmp}-----------------"
        return tmp
      end

      def end
        if object.until_tomorrow?  then 
          # end_date = Time.parse(BASEWEEK[object.day_of_week]).tomorrow
          # return "#{I18n.localize(end_date, format: :date)} #{end_time}"
          end_date = Time.parse(BASEWEEK[object.day_of_week]).tomorrow
          Rails.logger.info "-----------------end method true : #{end_date}-----------------"
          return "#{I18n.localize(end_date, format: :date)} #{end_time}"
        else
          # return "#{BASEWEEK[object.day_of_week]} #{end_time}"
          tmp = "#{BASEWEEK[object.day_of_week]} #{end_time}"
          Rails.logger.info "-----------------end method false : #{tmp}-----------------"
          return tmp
        end
      end

    end
  end
end
