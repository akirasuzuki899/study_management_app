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
        new_rich_text = study_note_params[:rich_text]
        old_rich_text = nil
        @study_note = current_user.study_notes.build(study_note_params)

        if sgids = @study_note.files_added?(new_rich_text, old_rich_text) then @study_note.attach_files(sgids) end

        if @study_note.save
          render json: { study_note: @study_note }
        else
          render json: { status: 'ERROR', study_note: @study_note.errors }
        end
      end

      def update
        new_rich_text = study_note_params[:rich_text]
        old_rich_text = @study_note.rich_text

        if sgids = @study_note.files_deleted?(new_rich_text, old_rich_text) then @study_note.delete_files(sgids) end
        if sgids = @study_note.files_added?(new_rich_text, old_rich_text)   then @study_note.attach_files(sgids) end

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

      def download
        url = URI.parse(params[:url])
        download_host = url.host
        host = request.domain

        if host == download_host
          
          path = url.path
          signed_id = get_signed_id(path)
          original_file = ActiveStorage::Blob.find_signed(signed_id)

          new_file = ActiveStorage::Blob.create_and_upload!(
            io: StringIO.new(original_file.download),
            filename: original_file.filename.to_s,
            content_type: original_file.content_type,
          )

          render json: { signed_id: new_file.signed_id(), filename: new_file.filename }

        else

        end
        
      end
      
      private

      def study_note_params
        params.require(:study_note).permit(:study_material_id, :title, :rich_text)
      end

      def correct_user
        @study_note = current_user.study_notes.find(params[:id])
        redirect_to root_url if @study_note.nil?
      end

      def get_signed_id(path)

        if path.include?("/rails/active_storage/blobs/redirect/")
          path[/rails\/active_storage\/blobs\/redirect\/(.+--.+)\//, 1]

        elsif path.include?("/rails/active_storage/blobs/proxy/")
          path[/rails\/active_storage\/blobs\/proxy\/(.+--.+)\//, 1]

        elsif path.include?("/rails/active_storage/blobs/")
          path[/rails\/active_storage\/blobs\/(.+--.+)\//, 1]
        end

      end

    end
  end
end
