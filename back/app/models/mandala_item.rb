class MandalaItem < ApplicationRecord
  belongs_to :mandala_group
  has_one :mandala_chart, through: :mandala_group
  has_one :study_notes, as: :noteable, dependent: :destroy

  validates :mandala_group_id, presence: true
  validates :place_number, presence: true, uniqueness: { scope: :mandala_group }, inclusion: { in: 1..9 }
  validates :text, length: { maximum: 50 }
  validates :is_finished, inclusion: { in: [true, false] }

  def center_item?
    self.place_number == 5 ? true : false
  end

  def center_group?
    place_number =  MandalaGroup.find(self.mandala_group_id).place_number
    place_number  == 5 ? true : false
  end

  def get_correspond_item 
    if self.center_group? && !self.center_item?
      MandalaItem.left_joins(:mandala_group, :mandala_chart)
        .find_by(place_number: 5, mandala_group: {place_number: self.place_number}, mandala_chart: {id: self.mandala_chart.id})
        
    elsif !self.center_group? &&  self.center_item?
      group_place_number = MandalaGroup.find(self.mandala_group_id).place_number
      MandalaItem.left_joins(:mandala_group, :mandala_chart)
        .find_by(place_number: group_place_number, mandala_group: {place_number: 5}, mandala_chart: {id: self.mandala_chart.id})
    end
  end

end
