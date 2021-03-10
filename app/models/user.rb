class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :study_materials, dependent: :destroy
  has_many :study_notes, dependent: :destroy
  validates :name, presence: true
  
end
