module Api
  module V1
    class StudyMaterialSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :title, :image_url, :is_completed

      def image_url
        object.rakuten_image_url || object.image_url
      end
    end
  end
end