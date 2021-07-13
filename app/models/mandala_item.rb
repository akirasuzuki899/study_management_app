class MandalaItem < ApplicationRecord
  belongs_to :mandala_group

  validates :mandala_group_id, presence: true
  validates :place_number, presence: true, uniqueness: { scope: :mandala_group }, inclusion: { in: 1..9 }
  validates :text, length: { maximum: 50 }
  validates :is_finished, inclusion: { in: [true, false] }

end
