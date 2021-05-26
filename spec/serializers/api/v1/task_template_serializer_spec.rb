require 'rails_helper'

module Api
  module V1
    RSpec.describe "TaskTemplateSerializer", type: :serializer do
      before do
        @user = FactoryBot.create(:user)
        @study_material = FactoryBot.create(:study_material, user_id: @user.id)
        @task_template = FactoryBot.build(:task_template, user_id: @user.id, study_material_id: @study_material.id)
        @subject = TaskTemplateSerializer.new(@task_template).serializable_hash
      end
    
      it 'json で次の属性を返すこと' do
        expect(@subject).to include(:id, :user_id, :study_material_id, :name, :day_of_week, :start_time, :end_time, :start, :end)
      end

      it 'json で正しい kye と value を返すこと' do
        expect(@subject[:user_id]).to eq(@user.id)
        expect(@subject[:study_material_id]).to eq(@study_material.id)
        expect(@subject[:name]).to eq(@task_template.name)
        expect(@subject[:day_of_week]).to eq(@task_template.day_of_week)
        expect(@subject[:start]).to eq("2000-01-03 00:00")
        expect(@subject[:end]).to eq("2000-01-03 01:00")
        expect(@subject[:start_time]).to eq("00:00")
        expect(@subject[:end_time]).to eq("01:00")
      end

      it 'end_time = 00:00 の時、当日の24:00に更新されれば有効 (dbでは深夜０時を00:00として扱うが,シリアライザーでは24:00として扱う)' do
        @task_template.assign_attributes({
          start_time: "23:00",
          end_time: "00:00",
        })
        subject = TaskTemplateSerializer.new(@task_template).serializable_hash
        expect(subject[:start]).to eq("2000-01-03 23:00")
        expect(subject[:end]).to eq("2000-01-03 24:00")
      end

      #以下, it 'dbの値が〇〇の時、シリアライザーの値が□□であると有効' do

      it 'end_time ≠ 00:00 かつ start_time > end_timeの時、endの値はstartの翌日であると有効' do
        @task_template.assign_attributes({
          start_time: "23:00",
          end_time: "00:15",
        })
        subject = TaskTemplateSerializer.new(@task_template).serializable_hash
        expect(subject[:start]).to eq("2000-01-03 23:00")
        expect(subject[:end]).to eq("2000-01-04 00:15")
      end

      it 'end_time ≠ 00:00 かつ start_time < end_timeの時、endとstartの値は同日であると有効' do
        @task_template.assign_attributes({
          start_time: "08:00",
          end_time: "10:00",
        })
        subject = TaskTemplateSerializer.new(@task_template).serializable_hash
        expect(subject[:start]).to eq("2000-01-03 08:00")
        expect(subject[:end]).to eq("2000-01-03 10:00")
      end

      it 'end_time ≠ 00:00 かつ start_time = end_timeの時、endの値はstartの翌日であると有効' do
        @task_template.assign_attributes({
          start_time: "08:00",
          end_time: "08:00",
        })
        subject = TaskTemplateSerializer.new(@task_template).serializable_hash
        expect(subject[:start]).to eq("2000-01-03 08:00")
        expect(subject[:end]).to eq("2000-01-04 08:00")
      end

      it 'end_time = 00:00 かつ start_time > end_timeの時、endとstartの値は同日であると有効' do
        @task_template.assign_attributes({
          start_time: "23:00",
          end_time: "00:00",
        })
        subject = TaskTemplateSerializer.new(@task_template).serializable_hash
        expect(subject[:start]).to eq("2000-01-03 23:00")
        expect(subject[:end]).to eq("2000-01-03 24:00")
      end

      it 'end_time = 00:00 かつ start_time = end_timeの時、endとstartの値は同日であると有効' do
        @task_template.assign_attributes({
          start_time: "00:00",
          end_time: "00:00",
        })
        subject = TaskTemplateSerializer.new(@task_template).serializable_hash
        expect(subject[:start]).to eq("2000-01-03 00:00")
        expect(subject[:end]).to eq("2000-01-03 24:00")
      end


      it '属性値start,endは曜日に対して特定の日付( 2000-01-03 ~ 2000-01-09 )に決まること'

    end

  end
end