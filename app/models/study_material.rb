class StudyMaterial < ApplicationRecord
  belongs_to :user
  has_many :study_notes, dependent: :destroy
  has_one_attached :picture

end
