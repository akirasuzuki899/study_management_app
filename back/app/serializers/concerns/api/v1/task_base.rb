module Api
  module V1
    module TaskBase
      extend ActiveSupport::Concern

      def start
        object.start_at ? I18n.l(object.start_at, format: :dateTime) : nil
      end
      
      def end
        object.end_at ? I18n.l(object.end_at, format: :dateTime) : nil
      end
    
    end
  end
end