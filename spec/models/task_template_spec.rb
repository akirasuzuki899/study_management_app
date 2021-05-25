require 'rails_helper'

RSpec.describe TaskTemplate, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @study_material = FactoryBot.create(:study_material, user_id: @user.id)
    @task_template = FactoryBot.build(:task_template, user_id: @user.id, study_material_id: @study_material.id)
  end

  it '有効な新規登録-日付をまたぐ時( 23:00 - 00:15 )' do
    @task_template.assign_attributes({
      start_time: "23:00",
      end_time: "00:15",
    })
    expect(@task_template).to  be_valid
  end
  
  it '有効な新規登録-日付をまたぐがない時( 00:00 - 00:15 )' do
    @task_template.assign_attributes({
      start_time: "00:00",
      end_time: "00:15",
    })
    expect(@task_template).to  be_valid
  end

  it '関連するユーザーが存在しなければ無効' do
    @task_template.user_id = nil
    @task_template.valid?
    expect(@task_template.errors[:user_id]).to  include("can't be blank")
  end

  it '関連する教材が存在しなければ無効' do
    @task_template.study_material_id = nil 
    @task_template.valid?
    expect(@task_template.errors[:study_material_id]).to  include("can't be blank")
  end

  it 'タイトルが存在しなければ無効' do
    @task_template.name = nil
    @task_template.valid?
    expect(@task_template.errors[:name]).to  include("can't be blank")
  end

  it 'タイトルが51文字以上であれば無効' do
    @task_template.name = "a"*51
    @task_template.valid?
    expect(@task_template.errors[:name]).to  include("is too long (maximum is 50 characters)")
  end

  it 'タイトルが50文字以下であれば有効' do
    @task_template.name = "a"*50
    @task_template.valid?
    expect(@task_template).to  be_valid
  end

  it '曜日が存在しなければ無効' do
    @task_template.day_of_week = nil
    @task_template.valid?
    expect(@task_template.errors[:day_of_week]).to  include("can't be blank")
  end

  it '曜日が["月","火","水","木","金","土","日"]のどれかで無い時に無効' do
    @task_template.day_of_week = "a"
    @task_template.valid?
    expect(@task_template.errors[:day_of_week]).to  include("is not included in the list")
  end

  it '開始時間が存在しなければ無効' do
    @task_template.start_time = nil
    @task_template.valid?
    expect(@task_template.errors[:start_time]).to  include("can't be blank")
  end

  it '終了時間が存在しなければ無効' do
    @task_template.start_time = nil
    @task_template.valid?
    expect(@task_template.errors[:start_time]).to  include("can't be blank")
  end

  it '合計時間が15分未満の時に無効(日付をまたぐ時)' do
    @task_template.assign_attributes({
      start_time: "23:55",
      end_time: "00:05",
    })
    @task_template.valid?
    expect(@task_template.errors[:total_time]).to  include("合計時間は15分以上にしてください")
  end

  it '合計時間が15分未満の時に無効(日付をまたがない時)' do
    @task_template.assign_attributes({
      start_time: "23:00",
      end_time: "23:05",
    })
    @task_template.valid?
    expect(@task_template.errors[:total_time]).to  include("合計時間は15分以上にしてください")
  end

  it 'メソッドテスト until_tomorrow?' do
    @task_template.assign_attributes({
      start_time: "23:00",
      end_time: "23:15",
    })
    expect(@task_template.until_tomorrow?).to eq(false)

    @task_template.assign_attributes({
      start_time: "23:00",
      end_time: "00:15",
    })
    expect(@task_template.until_tomorrow?).to eq(true)
  end
end