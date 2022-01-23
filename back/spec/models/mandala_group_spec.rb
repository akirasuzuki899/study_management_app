require 'rails_helper'

RSpec.describe MandalaGroup, type: :model do

  let(:mandala_group) { FactoryBot.create(:mandala_group) }

  it 'mandala_chart_id, place_number が存在すれば有効' do
    mandala_group.valid?
    expect(mandala_group).to  be_valid
  end

  it '関連する mandala_chart が存在しなければ無効' do
    mandala_group.mandala_chart_id = nil
    mandala_group.valid?
    expect(mandala_group.errors[:mandala_chart_id]).to  include("can't be blank")
  end

  it 'place_number が存在しなければ無効' do
    mandala_group.place_number = nil
    mandala_group.valid?
    expect(mandala_group.errors[:place_number]).to  include("can't be blank")
  end

  it 'place_number が mandala_chartのスコープ範囲で重複していれば無効' do
    mandala_group1 = FactoryBot.create(:mandala_group, place_number: 1)
    chart = mandala_group1.mandala_chart
    mandala_group2 = chart.mandala_groups.build(place_number: 1)
    mandala_group2.valid?
    expect(mandala_group2.errors[:place_number]).to  include("has already been taken")
  end

  it 'place_number が 1~9 以外で無効' do
    mandala_group.place_number = 0
    mandala_group.valid?
    expect(mandala_group.errors[:place_number]).to  include("is not included in the list")
    mandala_group.place_number = 10
    mandala_group.valid?
    expect(mandala_group.errors[:place_number]).to  include("is not included in the list")
  end
end
