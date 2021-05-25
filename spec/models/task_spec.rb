require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @study_material = FactoryBot.create(:study_material, user_id: @user.id)
    @task = FactoryBot.build(:task, user_id: @user.id, study_material_id: @study_material.id)
  end

  it '有効な新規登録-日付をまたぐ時' do
    @task.assign_attributes({
      start_at: "2050-05-17 23:00:00",
      end_at: "2050-05-18 01:00:00",
    })
    expect(@task).to  be_valid
  end

  it '有効な新規登録-日付をまたがない時' do
    @task.assign_attributes({
      start_at: "2050-05-17 23:00:00",
      end_at: "2050-05-17 23:30:00",
    })
    expect(@task).to  be_valid
  end

  it '関連するユーザーが存在しなければ無効' do
    @task.user_id = nil
    @task.valid?
    expect(@task.errors[:user_id]).to  include("can't be blank")
  end

  it '関連する教材が存在しなければ無効' do
    @task.study_material_id = nil 
    @task.valid?
    expect(@task.errors[:study_material_id]).to  include("can't be blank")
  end

  it 'タイトルが存在しなければ無効' do
    @task.name = nil
    @task.valid?
    expect(@task.errors[:name]).to  include("can't be blank")
  end

  it 'タイトルが51文字以上であれば無効' do
    @task.name = "a"*51
    @task.valid?
    expect(@task.errors[:name]).to  include("is too long (maximum is 50 characters)")
  end

  it 'タイトルが50文字以下であれば有効' do
    @task.name = "a"*50
    @task.valid?
    expect(@task).to  be_valid
  end

  it '開始時刻が存在しなければ無効' do
    @task.start_date = nil
    @task.valid?
    expect(@task.errors[:start_date]).to  include("can't be blank")
  end

  it '開始日のフォーマットが yyyy-mm-dd でなければ無効' do
    @task.start_date = "2021/05/11"
    @task.valid?
    expect(@task.errors[:start_date]).to  include("shoud be yyyy-mm-dd")
  end

  it '開始時刻のフォーマットが hh:mm でなければ無効' do
    @task.start_time = "1:20"
    @task.valid?
    expect(@task.errors[:start_time]).to  include("shoud be hh:mm")
  end

  it '終了日のフォーマットが yyyy-mm-dd でなければ無効' do
    @task.end_date = "2021/05/11"
    @task.valid?
    expect(@task.errors[:end_date]).to  include("shoud be yyyy-mm-dd")
  end

  it '終了時刻のフォーマットが hh:mm でなければ無効' do
    @task.end_time = "1:20"
    @task.valid?
    expect(@task.errors[:end_time]).to  include("shoud be hh:mm")
  end

  it '開始日時が終了日時より後であれば無効' do
    @task.assign_attributes({
      start_date: "2050-05-18",
      end_date: "2050-05-17",
    })
    @task.valid?
    expect(@task.errors[:end_at]).to  include("終了日時は開始日時より遅い時間を選択してください")
  end

  it '開始日時が現在より前でれば無効' do
    @task.assign_attributes({
      start_date: "2000-05-17",
      end_date: "2000-05-18",
    })
    @task.valid?
    expect(@task.errors[:start_at]).to  include("開始日時は現在の日時以降を選択してください")
  end

  it 'メソッドテスト set_start_at' do
    @task.start_date = nil
    @task.valid?
    expect(@task.start_at).to  eq(nil)

    @task.start_time = nil
    @task.valid?
    expect(@task.start_at).to  eq(nil)

    @task.end_date = nil
    @task.valid?
    expect(@task.end_at).to  eq(nil)

    @task.end_time = nil
    @task.valid?
    expect(@task.end_at).to  eq(nil)

    @task.assign_attributes({
      start_date: "2050-05-17",
      start_time: "00:00", 
      end_date: "2050-05-17",
      end_time: "01:00",
    })
    @task.valid?
    expect(@task.start_at).to  eq("2050-05-17 00:00:00.000000000 +0900")
    expect(@task.end_at).to  eq("2050-05-17 01:00:00.000000000 +0900")
  end

  it 'メソッドテスト self.create_next_week_tasks_by_task_templates'
  
end
