module Api
  module V1
    class TaskSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :study_material_id, :name, :start_at, :end_at
    
      belongs_to :user
      belongs_to :study_material
    
      def start_at
        I18n.l(object.start_at, format: :dateTime)
      end
    
      def end_at
        I18n.l(object.end_at, format: :dateTime)
      end
    end

  end
end
