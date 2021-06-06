module Api
  module V1
    class TaskSerializer < ActiveModel::Serializer
      include TaskBase
      attributes :id, :user_id, :study_material_id, :name, :start, :end, :start_date, :end_date, :start_time, :end_time, :color
    
      belongs_to :user
      belongs_to :study_material
      has_one :study_record
      
    end
  end
end