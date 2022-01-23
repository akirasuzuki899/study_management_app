require 'rails_helper'

RSpec.describe MandalaItem, type: :model do
  
  let(:mandala_item) { FactoryBot.create(:mandala_item) }

  it 'mandala_group_id, place_number が存在すれば有効' do
    mandala_item.valid?
    expect(mandala_item).to  be_valid
  end

  it '関連する mandala_group が存在しなければ無効' do
    mandala_item.mandala_group_id = nil
    mandala_item.valid?
    expect(mandala_item.errors[:mandala_group_id]).to  include("can't be blank")
  end

  it 'place_number が存在しなければ無効' do
    mandala_item.place_number = nil
    mandala_item.valid?
    expect(mandala_item.errors[:place_number]).to  include("can't be blank")
  end

  it 'place_number が mandala_groupのスコープ範囲で重複していれば無効' do
    mandala_item1 = FactoryBot.create(:mandala_item, place_number: 1)
    group = mandala_item1.mandala_group
    mandala_item2 = group.mandala_items.build(place_number: 1)
    mandala_item2.valid?
    expect(mandala_item2.errors[:place_number]).to  include("has already been taken")
  end

  it 'place_number が 1~9 以外で無効' do
    mandala_item.place_number = 0
    mandala_item.valid?
    expect(mandala_item.errors[:place_number]).to  include("is not included in the list")
    mandala_item.place_number = 10
    mandala_item.valid?
    expect(mandala_item.errors[:place_number]).to  include("is not included in the list")
  end

  it 'text が 51文字以上で無効' do
    mandala_item.text = "a"*51
    mandala_item.valid?
    expect(mandala_item.errors[:text]).to  include("is too long (maximum is 50 characters)")
  end

  it 'text が 50文字以下で有効' do
    mandala_item.text = "a"*50
    mandala_item.valid?
    expect(mandala_item).to  be_valid
  end

end
