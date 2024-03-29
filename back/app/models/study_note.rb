class StudyNote < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :noteable, polymorphic: true
  
  has_many_attached :files

  validates :user_id, presence: true
  validates :noteable_id, presence: true
  validates :noteable_type, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :rich_text, presence: true

  def removed_files(new_rich_text, old_rich_text)
    diff =  get_file_sgids(old_rich_text) - get_file_sgids(new_rich_text)
    return diff if diff.length > 0
  end

  def added_files(new_rich_text, old_rich_text)
    diff =  get_file_sgids(new_rich_text) - get_file_sgids(old_rich_text)
    return diff if diff.length > 0
  end

  def get_file_sgids(rich_text)
    return [] if rich_text.blank?

    rich_text_blocks = JSON.parse(rich_text)["blocks"]
    array_sgids = rich_text_blocks.map{ | block | block.dig( "data", "file", "sgid" )  }
    return array_sgids.compact
  end

  def delete_files(sgids)       #もっと効率よく処理ができると思うので、後日修正する
    sgids.each do |sgid|
      blob = ActiveStorage::Blob.find_signed(sgid)
      return ActiveStorage::Attachment.find_by(blob_id: blob.id).purge_later
    end
  end

  def attach_files(sgids)
    self.files.attach(sgids)
  end

  private

  def self.delete_unattached_files
    ActiveStorage::Blob.unattached.find_each(&:purge_later)
  end

end