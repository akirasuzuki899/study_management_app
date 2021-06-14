module Api
  module V1
    class StudyMaterialSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :title, :image_url, :is_completed


    end
  end
end