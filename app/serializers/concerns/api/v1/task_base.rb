module Api
  module V1
    module TaskBase
      extend ActiveSupport::Concern

      # def start_date
      #   I18n.l(object.start_date, format: :date)
      # end

      # def start_time
      #   I18n.l object.start_time
      # end

      # def end_date
      #   object.until_tomorrow? ? I18n.l(Time.parse(start_date).tomorrow, format: :date) : start_date
      # end

      # def end_time
      #   "00:00"
      # end

      def start
        I18n.l(object.start_at, format: :dateTime)
      end
      
      def end
        I18n.l(object.end_at, format: :dateTime)
      end
    
    end
  end
end