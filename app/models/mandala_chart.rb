class MandalaChart < ApplicationRecord
  belongs_to :user
  has_many :mandala_groups, dependent: :destroy

  validates :user_id, presence: true
  validates :title, length: { maximum: 50 }

  def create_mandala_groups
    # mandala_chart = current_user.MandalaChart.create()
    user = User.find(1)
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
end
