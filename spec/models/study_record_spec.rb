require 'rails_helper'

RSpec.describe StudyRecord, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @study_material = FactoryBot.create(:study_material, user_id: @user.id)
    @task = FactoryBot.create(:task, user_id: @user.id, study_material_id: @study_material.id)
    @study_record = FactoryBot.build(:study_record, user_id: @user.id, study_material_id: @study_material.id, task_id: @task.id )
  end

  it '有効な新規登録-日付をまたぐ時' do
    @study_record.assign_attributes({
      start_date: "2050-05-17",
      start_time: "23:00:00",
      end_time: "01:00:00",
    })
    expect(@study_record).to  be_valid
  end

  it '有効な新規登録-日付をまたぐ時(0時終了)' do
    @study_record.assign_attributes({
      start_date: "2050-05-17",
      start_time: "23:00:00",
      end_time: "00:00:00",
    })
    expect(@study_record).to  be_valid
  end

  it '有効な新規登録-日付をまたがない時' do
    @study_record.assign_attributes({
      start_date: "2050-05-17",
      start_time: "23:00:00",
      end_time: "23:30:00",
    })
    expect(@study_record).to  be_valid
  end

  it '関連するユーザーが存在しなければ無効' do
    @study_record.user_id = nil
    @study_record.valid?
    expect(@study_record.errors[:user_id]).to  include("can't be blank")
  end

  it '関連する教材が存在しなければ無効' do
    @study_record.study_material_id = nil 
    @study_record.valid?
    expect(@study_record.errors[:study_material_id]).to  include("can't be blank")
  end

  it '関連するタスクが存在しなければ無効' do
    @study_record.task_id = nil 
    @study_record.valid?
    expect(@study_record.errors[:task_id]).to  include("can't be blank")
  end

  it '開始日が存在しなければ無効' do
    @study_record.start_date = nil
    @study_record.valid?
    expect(@study_record.errors[:start_date]).to  include("can't be blank")
  end

  it '開始時間が存在しなければ無効' do
    @study_record.start_time = nil
    @study_record.valid?
    expect(@study_record.errors[:start_time]).to  include("can't be blank")
  end

  it '終了時間が存在しなければ無効' do
    @study_record.end_time = nil
    @study_record.valid?
    expect(@study_record.errors[:end_time]).to  include("can't be blank")
  end

  
end
