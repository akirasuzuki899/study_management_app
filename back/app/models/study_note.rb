class StudyNote < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :study_material
  
  has_many_attached :files

  validates :user_id, presence: true
  validates :study_material_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :rich_text, presence: true

  def files_deleted?(new_rich_text)
    diff =  get_files_sgid(self.rich_text) - get_files_sgid(new_rich_text)
    return diff if diff.length > 0
  end

  def get_files_sgid(rich_text)
    rich_text_blocks = JSON.parse(rich_text)["blocks"]
    array_sgids = rich_text_blocks.map{ | block | block.dig( "data", "file", "sgid" )  }
    return array_sgids
  end

  def delete_files(sgids)
    sgids.each do |sgid|
      ActiveStorage::Blob.find_signed(sgid).purge_later
    end
  end



end