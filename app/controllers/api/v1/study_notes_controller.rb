module Api
  module V1
    class StudyNotesController < ApplicationController
      before_action { ActionText::Content.renderer = ApplicationController.renderer.new(request.env) }
      before_action :authenticate_user!
      before_action :correct_user, only: [:edit, :update, :destroy]

      def index
        @study_notes = StudyNote.includes(:study_material).where(user_id: current_user.id).page(params[:page]).per(10)
        render json: { status: 'SUCCESS', 
                       message: 'Loaded posts', 
                       data: {
                         study_notes: @study_notes.as_json(
                           include: [:study_material], 
                           methods: [:study_material_image_url]
                         )
                       } 
                      }
      end

      def new
        @study_note = StudyNote.new
      end
      
      def create
        @study_note = StudyNote.new
        @study_note = current_user.study_notes.build(study_note_params)
        if @study_note.save
          render json: { status: 'SUCCESS', message: 'Loaded posts', data: @study_note }
        else
          render json: { status: 'ERROR', message: 'Loaded posts', data: @study_note.errors }
        end
      end

      def show
        @study_note = StudyNote.find(params[:id])
        if @study_note.present?
          render json: { status: 'SUCCESS', message: 'Loaded posts', data: @study_note }, methods: [:get_content, :study_material_image_url]
        else
          render json: { status: 'ERROR', message: 'Loaded posts', data: @study_note.errors }
        end
      end

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
        params.require(:study_note).permit(:page_number, :content, :study_material_id, :title).merge(content: params[:content])
      end

      def correct_user
        @study_note = current_user.study_notes.find_by(id: params[:id])
        redirect_to root_url if @study_note.nil?
      end
    end
  end
end
