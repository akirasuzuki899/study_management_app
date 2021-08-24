class StudyNote < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :study_material
  validates :user_id, presence: true
  validates :study_material_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :rich_text, presence: true

  def rich_text_changed?(params)
    old_rich_text = JSON.parse(self.rich_text)["blocks"]
    new_rich_text = JSON.parse(params[:rich_text])["blocks"]

    return old_rich_text != new_rich_text ? true : false
  end
end