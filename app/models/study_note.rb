class StudyNote < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :study_material
  has_rich_text :content
  validates :user_id, presence: true
  validates :study_material_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true

  # 紐づいている画像のURLを取得する
  def study_material_image_url
    study_material.image.attached? ? url_for(study_material.image) : nil
  end

  def get_content
    content.to_s
  end
end
