module Api
  module V1
    class TaskSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :study_material_id, :name, :start, :end
    
      belongs_to :user
      belongs_to :study_material
    
      def start
        I18n.l(object.start_at, format: :dateTime)
      end
    
      def end
        I18n.l(object.end_at, format: :dateTime)
      end
    end

  end
end
