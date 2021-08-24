module Api
  module V1
    class StudyNotesController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update, :destroy]

      def index
        study_notes = current_user.study_notes
        study_materials = current_user.study_materials
        render json: { 
          study_notes: study_notes,
          tree_view: ActiveModelSerializers::SerializableResource.new(study_materials, each_serializer: TreeViewSerializer).as_json
        }
      end
      
      def create
        @study_note = current_user.study_notes.build(study_note_params)
        if @study_note.save
          render json: { study_note: @study_note }
        else
          render json: { status: 'ERROR', study_note: @study_note.errors }
        end
      end

      def update
        @study_note.rich_text_changed?(params)
        debugger
        if @study_note.update(study_note_params)
          render json: { study_note: @study_note }
        else
          render json: { status: 'ERROR', message: 'Loaded posts', study_note: @study_note.errors }
        end
      end

      def destroy
        @study_note.destroy
        render json: { study_note: @study_note }
      end

      private

      def study_note_params
        params.require(:study_note).permit(:study_material_id, :title, :rich_text)
      end

      def correct_user
        @study_note = current_user.study_notes.find(params[:id])
        redirect_to root_url if @study_note.nil?
      end
    end
  end
end
