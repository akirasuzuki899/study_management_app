require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @study_material = FactoryBot.create(:study_material, user_id: @user.id)
    @task = FactoryBot.build(:task, user_id: @user.id, study_material_id: @study_material.id)
  end

  it '有効な新規登録-日付をまたぐ時' do
    @task.assign_attributes({
      start_date: "2050-05-17",
      start_time: "23:00:00",
      end_time: "01:00:00",
    })
    expect(@task).to  be_valid
  end

  it '有効な新規登録-日付をまたがない時' do
    @task.assign_attributes({
      start_date: "2050-05-17",
      start_time: "23:00:00",
      end_time: "23:30:00",
      })
      expect(@task).to  be_valid
    end

    it '有効な新規登録-日付をまたがない時(24時終了)' do
      @task.assign_attributes({
        start_date: "2050-05-17",
        start_time: "23:00:00",
        end_time: "24:00:00",
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

  it '開始日が存在しなければ無効' do
    @task.start_date = nil
    @task.valid?
    expect(@task.errors[:start_date]).to  include("can't be blank")
  end
  
  it '開始時間が存在しなければ無効' do
    @task.start_time = nil
    @task.valid?
    expect(@task.errors[:start_time]).to  include("can't be blank")
  end

  it '終了時間が存在しなければ無効' do
    @task.end_time = nil
    @task.valid?
    expect(@task.errors[:end_time]).to  include("can't be blank")
  end

  it '開始日が現在より前でれば無効' do
    @task.assign_attributes({
      start_date: "2000-05-17",
    })
    @task.valid?
    expect(@task.errors[:start]).to  include("開始日時は現在の日時以降を選択してください")
  end

  it '合計時間が15分未満の時に無効(日付をまたぐ時)' do
    @task.assign_attributes({
      start_date: "2050-05-17",
      start_time: "23:55",
      end_time: "00:05",
    })
    @task.valid?
    expect(@task.errors[:total_time]).to  include("合計時間は15分以上にしてください")
  end

  it '合計時間が15分未満の時に無効(日付をまたがない時)' do
    @task.assign_attributes({
      start_time: "23:00",
      end_time: "23:05",
    })
    @task.valid?
    expect(@task.errors[:total_time]).to  include("合計時間は15分以上にしてください")

    @task.assign_attributes({
      start_time: "23:55",
      end_time: "24:00",
    })
    @task.valid?
    expect(@task.errors[:total_time]).to  include("合計時間は15分以上にしてください")

    @task.assign_attributes({
      start_time: "00:00",
      end_time: "00:05",
    })
    @task.valid?
    expect(@task.errors[:total_time]).to  include("合計時間は15分以上にしてください")
  end


  it 'メソッドテスト until_tomorrow?' do
    @task.assign_attributes({
      start_time: "23:00",
      end_time: "00:15",
    })
    expect(@task.until_tomorrow?).to eq(true)

    @task.assign_attributes({
      start_time: "23:00",
      end_time: "23:00",
    })
    expect(@task.until_tomorrow?).to eq(true)

    @task.assign_attributes({
      start_time: "00:00",
      end_time: "24:00",
    })
    expect(@task.until_tomorrow?).to eq(false)

    @task.assign_attributes({
      start_time: "23:00",
      end_time: "24:00",
    })
    expect(@task.until_tomorrow?).to eq(false)

    @task.assign_attributes({
      start_time: "23:00",
      end_time: "23:15",
    })
    expect(@task.until_tomorrow?).to eq(false)
  end

  it 'メソッドテスト until_midnight?' do
    @task.assign_attributes({
      start_time: "23:00",
      end_time: "24:00",
    })
    expect(@task.until_midnight?).to eq(true)

    @task.assign_attributes({
      start_time: "00:00",
      end_time: "24:00",
    })
    expect(@task.until_midnight?).to eq(true)

    @task.assign_attributes({
      start_time: "00:00",
      end_time: "00:15",
    })
    expect(@task.until_midnight?).to eq(false)

    @task.assign_attributes({
      start_time: "23:00",
      end_time: "00:15",
    })
    expect(@task.until_midnight?).to eq(false)
  end

  it 'メソッドテスト start' do
    @task.start_date = nil
    expect(@task.start_at).to  eq(nil)

    @task.start_time = nil
    expect(@task.start_at).to  eq(nil)

    @task.assign_attributes({
      start_date: "2050-05-17",
      start_time: "00:00",                       #start_timeの最小値
      })
    @task.valid?
    expect(@task.start_at).to  eq("2050-05-17 00:00:00.000000000 +0900")

    @task.assign_attributes({
      start_date: "2050-05-17",
      start_time: "23:45",                       #start_timeの最大値
      })
    @task.valid?
    expect(@task.start_at).to  eq("2050-05-17 23:45:00.000000000 +0900")
  end

  it 'メソッドテスト end' do
    @task.end_time = nil
    expect(@task.end_at).to  eq(nil)
    
    @task.assign_attributes({
      start_time: "23:00",
      end_time: "00:15",                           #end_timeの最小値
      })
    @task.valid?
    expect(@task.end_at).to  eq("2050-05-18 00:15:00.000000000 +0900")

    @task.assign_attributes({
      end_time: "24:00",                           #end_timeの最大値
      })
    @task.valid?
    expect(@task.end_at).to  eq("2050-05-18 00:00:00.000000000 +0900")

  end

  it 'メソッドテスト self.set_next_week_date' do
    today = Time.parse("2024-02-19 10:00")         #月曜
    next_week = { 
      "月" => I18n.l( today.next_week(:monday), format: :date ) , 
      "火" => I18n.l( today.next_week(:tuesday), format: :date )  , 
      "水" => I18n.l( today.next_week(:wednesday), format: :date )  , 
      "木" => I18n.l( today.next_week(:thursday), format: :date )  , 
      "金" => I18n.l( today.next_week(:friday), format: :date )  , 
      "土" => I18n.l( today.next_week(:saturday), format: :date )  , 
      "日" => I18n.l( today.next_week(:sunday), format: :date )  , 
    }  
    expect(next_week["月"]).to eq("2024-02-26")
    expect(next_week["火"]).to eq("2024-02-27")
    expect(next_week["水"]).to eq("2024-02-28")
    expect(next_week["木"]).to eq("2024-02-29")
    expect(next_week["金"]).to eq("2024-03-01")
    expect(next_week["土"]).to eq("2024-03-02")
    expect(next_week["日"]).to eq("2024-03-03")

    today = Time.parse("2024-02-25 10:00")         #日曜
    next_week = { 
      "月" => I18n.l( today.next_week(:monday), format: :date ) , 
      "火" => I18n.l( today.next_week(:tuesday), format: :date )  , 
      "水" => I18n.l( today.next_week(:wednesday), format: :date )  , 
      "木" => I18n.l( today.next_week(:thursday), format: :date )  , 
      "金" => I18n.l( today.next_week(:friday), format: :date )  , 
      "土" => I18n.l( today.next_week(:saturday), format: :date )  , 
      "日" => I18n.l( today.next_week(:sunday), format: :date )  , 
    }  
    expect(next_week["月"]).to eq("2024-02-26")
    expect(next_week["火"]).to eq("2024-02-27")
    expect(next_week["水"]).to eq("2024-02-28")
    expect(next_week["木"]).to eq("2024-02-29")
    expect(next_week["金"]).to eq("2024-03-01")
    expect(next_week["土"]).to eq("2024-03-02")
    expect(next_week["日"]).to eq("2024-03-03")
  end

  



  it 'メソッドテスト self.create_next_week_tasks_by_tasks'
  
end
