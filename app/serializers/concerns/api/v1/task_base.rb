module Api
  module V1
    module TaskBase
      extend ActiveSupport::Concern

      def start
        I18n.l(object.start_at, format: :dateTime)
      end
      
      def end
        I18n.l(object.end_at, format: :dateTime)
      end
    
    end
  end
end