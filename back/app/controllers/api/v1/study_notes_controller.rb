module Api
  module V1
    class StudyNotesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_note, only: [:update, :destroy]

      require 'open-uri'

      def index
        render json: { 
          tree_view: ActiveModelSerializers::SerializableResource.new(@noteables, each_serializer: @serializer).as_json
        }
      end
      
      def create
        new_rich_text = study_note_params[:rich_text]
        old_rich_text = nil
        @study_note = @noteable.study_notes.build(study_note_params)
        @study_note.user_id = current_user.id

        if sgids = @study_note.added_files(new_rich_text, old_rich_text) then @study_note.attach_files(sgids) end

        if @study_note.save
          render json: { study_note: @study_note, noteable: @noteable }
        else
          render json: { status: 'ERROR', study_note: @study_note.errors }
        end
      end

      def update
        old_note = @study_note.attributes
        old_rich_text = @study_note.rich_text
        new_rich_text = study_note_params[:rich_text]

        if sgids = @study_note.removed_files(new_rich_text, old_rich_text) then @study_note.delete_files(sgids) end
        if sgids = @study_note.added_files(new_rich_text, old_rich_text)   then @study_note.attach_files(sgids) end

        if @study_note.update(study_note_params)
          render json: { study_note: @study_note, noteable: @study_note.noteable, old_note: old_note, old_noteable: @noteable}
        else
          render json: { status: 'ERROR', message: 'Loaded posts', study_note: @study_note.errors }
        end
      end

      def destroy
        @study_note.destroy
        render json: { study_note: @study_note, noteable: @noteable }
      end

      def download
        url = URI.parse(params[:url])
        download_host = url.host
        host = request.domain

        new_file = 
          host == download_host ? Downloader.copy(url)
                                : Downloader.download(url)

        new_file ? ( render json: { signed_id: new_file.signed_id(), filename: new_file.filename } )
                 : ( render json: { message: 'ERROR' }, status: 400 )
      end
      
      private

      def study_note_params
        params.require(:study_note).permit(:noteable_id, :title, :rich_text)
      end

      def set_note
        @study_note = current_user.study_notes.find(params[:id])
        @noteable = @study_note.noteable
        redirect_to root_url if @study_note.nil?
      end

    end
  end
end
