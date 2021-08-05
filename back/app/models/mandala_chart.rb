class MandalaChart < ApplicationRecord
  belongs_to :user
  has_many :mandala_groups, dependent: :destroy
  has_many :mandala_items, through: :mandala_groups

  validates :user_id, presence: true

  def self.create_mandala_chart(user_id)
    # mandala_chart = current_user.MandalaChart.create()
    user = User.find(user_id)
    mandala_chart = user.mandala_charts.create()
    mandala_groups = (1..9).map do |i|
      mandala_chart.mandala_groups.create(
        place_number: i
      )
    end

    mandala_groups.each do |mandala_group|
      (1..9).map do |i|
        mandala_group.mandala_items.create(
          place_number: i
        )
      end
    end
    
  end

  def initItems
    self.mandala_items.update_all(
      text: "",
      is_finished: false,
      url: "",
    )
  end
end
