module Api
  module V1
    class MandalaItems::StudyNotesController < StudyNotesController
      before_action :set_noteables, only: [:index]
      before_action :set_noteable, only: [:create]

      private

      def set_noteables
        @serializer = MandalaItemNoteSerializer
        @noteables = current_user.mandala_charts.last.mandala_groups
      end
      def set_noteable
        @noteable = StudyMaterial.find(params[:study_material_id])
      end
    end
  end
end