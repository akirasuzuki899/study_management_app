class StudyNote < ApplicationRecord
  belongs_to :user
  belongs_to :study_material
  has_rich_text :content
end
