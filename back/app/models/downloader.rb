class Downloader
  attr_reader :url

  def self.download(url)
    ActiveStorage::Blob.create_and_upload!(
      io: open(url),
      filename:  File.basename(url.path)
    )
  end

  def self.copy(url)
    signed_id = self.get_signed_id(url.path)
    original_file = ActiveStorage::Blob.find_signed(signed_id)

    ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(original_file.download),
      filename: original_file.filename.to_s
    )
  end

  def self.get_signed_id(path)

    if path.include?("/rails/active_storage/blobs/redirect/")
      path[/rails\/active_storage\/blobs\/redirect\/(.+--.+)\//, 1]

    elsif path.include?("/rails/active_storage/blobs/proxy/")
      path[/rails\/active_storage\/blobs\/proxy\/(.+--.+)\//, 1]

    elsif path.include?("/rails/active_storage/blobs/")
      path[/rails\/active_storage\/blobs\/(.+--.+)\//, 1]
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

end