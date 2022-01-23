require 'rails_helper'

RSpec.describe MandalaChart, type: :model do

  let(:mandala_chart) { FactoryBot.create(:mandala_chart) }

  it 'user_id が存在すれば有効' do
    mandala_chart.valid?
    expect(mandala_chart).to  be_valid
  end

  it '関連する user が存在しなければ無効' do
    mandala_chart.user_id = nil
    mandala_chart.valid?
    expect(mandala_chart.errors[:user_id]).to  include("can't be blank")
  end
  
end
