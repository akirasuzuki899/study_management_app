module Api
  module V1
    class TaskSerializer < ActiveModel::Serializer
      include TaskBase
      attributes :id, :user_id, :study_material_id, :name, :start, :end, :color
      # :start_date, :end_date, :start_time, :end_time
    
      belongs_to :user
      belongs_to :study_material, serializer: StudyMaterialSerializer
      has_one :study_record, serializer: StudyRecordSerializer
      
    end
  end
end