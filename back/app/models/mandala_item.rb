class MandalaItem < ApplicationRecord
  belongs_to :mandala_group

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
    if self.center_group? 
      MandalaItem.left_joins(:mandala_group)
        .find_by(place_number: 5, mandala_group: {place_number: self.place_number})
    elsif self.center_item?
      group_place_number = MandalaGroup.find(self.mandala_group_id).place_number
      MandalaItem.left_joins(:mandala_group)
        .find_by(place_number: group_place_number, mandala_group: {place_number: 5})
    end
  end

  def update_correspond_item(params)
    self.update(params)
  end

end
