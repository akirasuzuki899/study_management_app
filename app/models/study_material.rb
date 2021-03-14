class StudyMaterial < ApplicationRecord
  belongs_to :user
  has_many :study_notes, dependent: :destroy
  has_one_attached :picture
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :picture,
            blob: { content_type: :image, size_range: 1..5.megabytes }
end
