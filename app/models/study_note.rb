class StudyNote < ApplicationRecord
  belongs_to :user
  belongs_to :study_material
  has_rich_text :content
  validates :user_id, presence: true
  validates :study_material_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true
end
