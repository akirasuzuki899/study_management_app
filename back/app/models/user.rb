class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable
  include DeviseTokenAuth::Concerns::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #   devise :database_authenticatable, :registerable,
  #          :recoverable, :rememberable, :validatable
  has_many :study_materials, dependent: :destroy
  has_many :study_notes, dependent: :destroy
  has_many :task_templates, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :study_records , dependent: :destroy
  has_many :mandala_charts , dependent: :destroy

  after_create :create_mandala_chart
  
  validates :name, presence: true

  def create_mandala_chart
    MandalaChart.create_mandala_chart(self.id)
  end
end
