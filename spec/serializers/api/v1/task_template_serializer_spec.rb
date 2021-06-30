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
        expect(@subject).to include(:id, :user_id, :study_material_id, :name, :day_of_week, :start, :end, :prev_week_sunday_task, :color)
      end

      it 'json で正しい kye と value を返すこと' do
        expect(@subject[:user_id]).to eq(@user.id)
        expect(@subject[:study_material_id]).to eq(@study_material.id)
        expect(@subject[:name]).to eq(@task_template.name)
        expect(@subject[:day_of_week]).to eq(@task_template.day_of_week)
        expect(@subject[:start]).to eq("2000-01-03 00:00")               #月曜日
        expect(@subject[:end]).to eq("2000-01-03 01:00")
        expect(@subject[:prev_week_sunday_task]).to eq(nil)
        expect(@subject[:color]).to eq("blue")
      end

      it 'end_time = 00:00 かつ start_time > end_timeの時、endはstartの翌日であると有効' do
        @task_template.assign_attributes({
          start_time: "23:00",
          end_time: "00:00",
        })
        subject = TaskTemplateSerializer.new(@task_template).serializable_hash
        expect(subject[:start]).to eq("2000-01-03 23:00")
        expect(subject[:end]).to eq("2000-01-04 00:00")
      end

      it 'end_time = 00:00 かつ start_time = end_timeの時、endはstartの翌日であると有効' do
        @task_template.assign_attributes({
          start_time: "00:00",
          end_time: "00:00",
        })
        subject = TaskTemplateSerializer.new(@task_template).serializable_hash
        expect(subject[:start]).to eq("2000-01-03 00:00")
        expect(subject[:end]).to eq("2000-01-04 00:00")
      end

      it 'end_time ≠ 00:00 かつ start_time > end_timeの時、endはstartの翌日であると有効' do
        @task_template.assign_attributes({
          start_time: "23:00",
          end_time: "00:15",
        })
        subject = TaskTemplateSerializer.new(@task_template).serializable_hash
        expect(subject[:start]).to eq("2000-01-03 23:00")
        expect(subject[:end]).to eq("2000-01-04 00:15")
      end

      it 'end_time ≠ 00:00 かつ start_time < end_timeの時、endとstartは同じ日付であると有効' do
        @task_template.assign_attributes({
          start_time: "08:00",
          end_time: "10:00",
        })
        subject = TaskTemplateSerializer.new(@task_template).serializable_hash
        expect(subject[:start]).to eq("2000-01-03 08:00")
        expect(subject[:end]).to eq("2000-01-03 10:00")
      end

      it 'end_time ≠ 00:00 かつ start_time = end_timeの時、endはstartの翌日であると有効' do
        @task_template.assign_attributes({
          start_time: "08:00",
          end_time: "08:00",
        })
        subject = TaskTemplateSerializer.new(@task_template).serializable_hash
        expect(subject[:start]).to eq("2000-01-03 08:00")
        expect(subject[:end]).to eq("2000-01-04 08:00")
      end

      it '日曜日のタスクが月曜日に及ぶ場合、prev_week_sunday_taskに一週間前の日付で日曜日のタスクが作成されると有効' do
        @task_template.assign_attributes({
          start_time: "23:00",
          end_time: "02:00",
          day_of_week: "日",
          start_date: "2000-01-09",
        })
        subject = TaskTemplateSerializer.new(@task_template).serializable_hash
        expect(subject[:start]).to eq("2000-01-09 23:00")
        expect(subject[:end]).to eq("2000-01-10 02:00")
        expect(subject[:prev_week_sunday_task][:start]).to eq("2000-01-02 23:00")
        expect(subject[:prev_week_sunday_task][:end]).to eq("2000-01-03 02:00")
      end

      it '属性値start,endは曜日に対して特定の日付( 2000-01-03 ~ 2000-01-09 )に決まること'

    end

  end
end