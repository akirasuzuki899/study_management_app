class StudyMaterial < ApplicationRecord
  include Rails.application.routes.url_helpers
  require 'open-uri'
  attr_accessor :rakuten_image_url

  belongs_to :user
  has_many :study_notes, dependent: :destroy
  has_many :study_records
  has_one_attached :image
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false , scope: :user}
  validates :image,
            blob: { content_type: :image, size_range: 1..5.megabytes }

  def attach_rakuten_image(url, title)
    image = open(url)
    self.image.attach(io: image, filename: "#{title}.jpg")
  end

  def image_url
    # 紐づいている画像のURLを取得する
    image.attached? ? url_for(image) : nil
  end
end
