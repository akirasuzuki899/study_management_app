class StudyNote < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :study_material
  validates :user_id, presence: true
  validates :study_material_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :rich_text, presence: true
end