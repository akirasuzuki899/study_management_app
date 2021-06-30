module Api
  module V1
    class StudyRecordSerializer < ActiveModel::Serializer
      include TaskBase
      attributes :id, :user_id, :study_material_id, :task_id, :start, :end, :is_finished

    end
  end
end