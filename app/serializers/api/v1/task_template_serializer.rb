module Api
  module V1
    class TaskTemplateSerializer < ActiveModel::Serializer
      include TaskBase
      attributes :id, :user_id, :study_material_id, :name, :day_of_week, :start, :end, :start_time, :end_time

      belongs_to :user
      belongs_to :study_material

    end
  end
end
