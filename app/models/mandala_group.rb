class MandalaGroup < ApplicationRecord
  belongs_to :mandala_chart
  has_many :mandala_items, dependent: :destroy

  validates :mandala_chart_id, presence: true
  validates :place_number, presence: true, uniqueness: { scope: :mandala_chart }, inclusion: { in: 1..9 }
end
