module Api
  module V1
    class StudyNotesController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:edit, :update, :destroy]

      def index
        @study_notes = current_user.study_notes.page(params[:page]).per(5)
        render json: { status: 'SUCCESS', message: 'Loaded posts', data: @study_notes, methods: [:image_url] }
      end

      def new
        @study_note = StudyNote.new
      end

      def create
        @study_note = current_user.study_notes.build(study_note_params)
        if @study_note.save
          redirect_to study_notes_path
        else
          render 'new'
        end
      end

      def show; end

      def edit; end

      def update
        if @study_note.update(study_note_params)
          redirect_to study_notes_path
        else
          render 'edit'
        end
      end

      def destroy
        @study_note.destroy
        redirect_to study_notes_path
      end

      private

      def study_note_params
        params.require(:study_note).permit(:page_number, :content, :study_material_id, :title)
      end

      def correct_user
        @study_note = current_user.study_notes.find_by(id: params[:id])
        redirect_to root_url if @study_note.nil?
      end
    end
  end
end
