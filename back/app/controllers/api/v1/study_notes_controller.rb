module Api
  module V1
    class StudyNotesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_note, only: [:update, :destroy]

      require 'open-uri'

      def index
        render json: { 
          tree_view: ActiveModelSerializers::SerializableResource.new(@noteables, each_serializer: TreeViewSerializer).as_json
        }
      end
      
      def create
        new_rich_text = study_note_params[:rich_text]
        old_rich_text = nil
        @study_note = @noteable.study_notes.build(study_note_params)
        @study_note.user_id = current_user.id

        if sgids = @study_note.files_added?(new_rich_text, old_rich_text) then @study_note.attach_files(sgids) end

        if @study_note.save
          render json: { study_note: @study_note }
        else
          render json: { status: 'ERROR', study_note: @study_note.errors }
        end
      end

      def update
        old_note = @study_note.deep_dup
        old_rich_text = @study_note.rich_text
        new_rich_text = study_note_params[:rich_text]

        if sgids = @study_note.files_deleted?(new_rich_text, old_rich_text) then @study_note.delete_files(sgids) end
        if sgids = @study_note.files_added?(new_rich_text, old_rich_text)   then @study_note.attach_files(sgids) end

        if @study_note.update(study_note_params)
          render json: { study_note: @study_note, old_note: old_note }
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

          signed_id = get_signed_id(url.path)
          original_file = ActiveStorage::Blob.find_signed(signed_id)

          new_file = ActiveStorage::Blob.create_and_upload!(
            io: StringIO.new(original_file.download),
            filename: original_file.filename.to_s
          )

          new_file ? ( render json: { signed_id: new_file.signed_id(), filename: new_file.filename } )
                   : ( render json: { message: 'ERROR' }, status: 400 )

        else

          new_file = ActiveStorage::Blob.create_and_upload!(
            io: open(url),
            filename:  File.basename(url.path)
          )

          new_file ? ( render json: { signed_id: new_file.signed_id(), filename: new_file.filename } )
                   : ( render json: { message: 'ERROR' }, status: 400 )

        end
      end

      # def url_metadata
      #   if meta = MetaInspector.new(params[:url])
      #     render json: {
      #       success: 1,
      #       meta: {
      #         title: meta.title,
      #         description: meta.description,
      #         image: { url: meta.image}}}
      #   else
      #     render json: { message: 'ERROR' }, status: 400 
      #   end
      # end

      
      private

      def study_note_params
        params.require(:study_note).permit(:noteable_id, :title, :rich_text)
      end

      def set_note
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
