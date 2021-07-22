require 'rails_helper'

RSpec.describe MandalaGroup, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @mandala_chart = FactoryBot.create(:mandala_chart, user_id: @user.id)
    @mandala_group = FactoryBot.build(:mandala_group, mandala_chart_id: @mandala_chart.id)
  end

  it 'すべての値が有効な値であれば有効' do
    @mandala_group.valid?
    expect(@mandala_group).to  be_valid
  end

  it '関連する mandala_chart が存在しなければ無効' do
    @mandala_group.mandala_chart_id = nil
    @mandala_group.valid?
    expect(@mandala_group.errors[:mandala_chart_id]).to  include("can't be blank")
  end

  it 'place_number が存在しなければ無効' do
    @mandala_group.place_number = nil
    @mandala_group.valid?
    expect(@mandala_group.errors[:place_number]).to  include("can't be blank")
  end

  it 'place_number が mandala_chartのスコープ範囲で重複していれば無効' do
    mandala_group1 = FactoryBot.create(:mandala_group, mandala_chart_id: @mandala_chart.id, place_number: 1)
    mandala_group2 = FactoryBot.build(:mandala_group, mandala_chart_id: @mandala_chart.id, place_number: 1)
    mandala_group2.valid?
    expect(mandala_group2.errors[:place_number]).to  include("has already been taken")
  end
end
