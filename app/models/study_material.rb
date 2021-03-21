class StudyMaterial < ApplicationRecord
  require 'open-uri'
  attr_accessor :image_url

  belongs_to :user
  has_many :study_notes, dependent: :destroy
  has_one_attached :image
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :image,
            blob: { content_type: :image, size_range: 1..5.megabytes }

  def attach_url_image(url, title)
    image = open(url)
    self.image.attach(io: image, filename: "#{title}.jpg")
  end
end
