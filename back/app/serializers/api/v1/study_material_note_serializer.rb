module Api
  module V1
    class StudyMaterialNoteSerializer < ActiveModel::Serializer
      attributes :id, :title, :image_url, :children

      def children
        object.study_notes
      end
    end
  end
end