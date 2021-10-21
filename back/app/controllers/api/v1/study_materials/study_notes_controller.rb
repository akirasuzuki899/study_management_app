module Api
  module V1
    class StudyMaterials::StudyNotesController < StudyNotesController
      before_action :set_noteables, only: [:index]
      before_action :set_noteable, only: [:create]

      private

      def set_noteables
        @noteables = current_user.study_materials
      end
      def set_noteable
        @noteable = StudyMaterial.find(params[:study_material_id])
      end
    end
  end
end