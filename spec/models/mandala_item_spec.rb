require 'rails_helper'

RSpec.describe MandalaItem, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @mandala_chart = FactoryBot.create(:mandala_chart, user_id: @user.id)
    @mandala_group = FactoryBot.create(:mandala_group, mandala_chart_id: @mandala_chart.id)
    @mandala_item = FactoryBot.build(:mandala_item, mandala_group_id: @mandala_group.id)
  end

  it 'すべての値が有効な値であれば有効' do
    @mandala_item.valid?
    expect(@mandala_item).to  be_valid
  end

  it '関連する mandala_group が存在しなければ無効' do
    @mandala_item.mandala_group_id = nil
    @mandala_item.valid?
    expect(@mandala_item.errors[:mandala_group_id]).to  include("can't be blank")
  end

  it 'place_number が存在しなければ無効' do
    @mandala_item.place_number = nil
    @mandala_item.valid?
    expect(@mandala_item.errors[:place_number]).to  include("can't be blank")
  end

  it 'place_number が mandala_groupのスコープ範囲で重複していれば無効' do
    mandala_item1 = FactoryBot.create(:mandala_item, mandala_group_id: @mandala_group.id, place_number: 1)
    mandala_item2 = FactoryBot.build(:mandala_item, mandala_group_id: @mandala_group.id, place_number: 1)
    mandala_item2.valid?
    expect(mandala_item2.errors[:place_number]).to  include("has already been taken")
  end

  it 'text が 51文字以上で無効' do
    @mandala_item.text = "a"*51
    @mandala_item.valid?
    expect(@mandala_item.errors[:text]).to  include("is too long (maximum is 50 characters)")
  end

  it 'text が 50文字以下で有効' do
    @mandala_item.text = "a"*50
    @mandala_item.valid?
    expect(@mandala_item).to  be_valid
  end

end
