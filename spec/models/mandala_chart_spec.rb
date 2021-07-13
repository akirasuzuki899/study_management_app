require 'rails_helper'

RSpec.describe MandalaChart, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @mandala_chart = FactoryBot.build(:mandala_chart, user_id: @user.id)
  end

  it 'すべての値が有効な値であれば有効' do
    @mandala_chart.valid?
    expect(@mandala_chart).to  be_valid
  end

  it '関連する user が存在しなければ無効' do
    @mandala_chart.user_id = nil
    @mandala_chart.valid?
    expect(@mandala_chart.errors[:user_id]).to  include("can't be blank")
  end

  it 'title が 51文字以上で無効' do
    @mandala_chart.title = "a"*51
    @mandala_chart.valid?
    expect(@mandala_chart.errors[:title]).to  include("is too long (maximum is 50 characters)")
  end

  it 'title が 50文字以下で有効' do
    @mandala_chart.title = "a"*50
    @mandala_chart.valid?
    expect(@mandala_chart).to  be_valid
  end
end
