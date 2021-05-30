module Api
  module V1
    module TaskBase
      extend ActiveSupport::Concern

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
        object.until_midnight? ? "24:00" : (I18n.l object.end_time)
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