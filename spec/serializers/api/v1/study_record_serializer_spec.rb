require 'rails_helper'
module Api
  module V1
    RSpec.describe "StudyRecordSerializer", type: :serializer do
      before do
        @user = FactoryBot.create(:user)
        @study_material = FactoryBot.create(:study_material, user_id: @user.id)
        @task = FactoryBot.create(:task, user_id: @user.id, study_material_id: @study_material.id)
        @study_record = FactoryBot.create(:study_record, user_id: @user.id, study_material_id: @study_material.id, task_id: @task.id)
        @subject = StudyRecordSerializer.new(@study_record).serializable_hash
      end

      it 'json で次の属性を返すこと' do
        expect(@subject).to include(:id, :user_id, :study_material_id, :start, :end, :is_finished)
      end

      it 'json で正しい kye と value を返すこと' do
        expect(@subject[:user_id]).to eq(@user.id)
        expect(@subject[:study_material_id]).to eq(@study_material.id)
        expect(@subject[:task_id]).to eq(@task.id)
        expect(@subject[:start]).to eq("2050-05-17 10:00")
        expect(@subject[:end]).to eq("2050-05-17 11:00")
        expect(@subject[:is_finished]).to eq(false)
      end

      it 'end_time = 00:00 かつ start_time > end_timeの時、endはstartの翌日であると有効' do
          @study_record.assign_attributes({
          start_time: "23:00",
          end_time: "00:00",
        })
        subject = StudyRecordSerializer.new(@study_record).serializable_hash
        expect(subject[:start]).to eq("2050-05-17 23:00")
        expect(subject[:end]).to eq("2050-05-18 00:00")
      end

      it 'end_time = 00:00 かつ start_time = end_timeの時、endはstartの翌日であると有効' do
        @study_record.assign_attributes({
          start_time: "00:00",
          end_time: "00:00",
        })
        subject = StudyRecordSerializer.new(@study_record).serializable_hash
        expect(subject[:start]).to eq("2050-05-17 00:00")
        expect(subject[:end]).to eq("2050-05-18 00:00")
      end

      it 'end_time ≠ 00:00 かつ start_time > end_timeの時、endはstartの翌日であると有効' do
        @study_record.assign_attributes({
          start_time: "23:00",
          end_time: "00:15",
        })
        subject = StudyRecordSerializer.new(@study_record).serializable_hash
        expect(subject[:start]).to eq("2050-05-17 23:00")
        expect(subject[:end]).to eq("2050-05-18 00:15")
      end

      it 'end_time ≠ 00:00 かつ start_time < end_timeの時、endとstartは同じ日付であると有効' do
        @study_record.assign_attributes({
          start_time: "08:00",
          end_time: "10:00",
        })
        subject = StudyRecordSerializer.new(@study_record).serializable_hash
        expect(subject[:start]).to eq("2050-05-17 08:00")
        expect(subject[:end]).to eq("2050-05-17 10:00")
      end

      it 'end_time ≠ 00:00 かつ start_time = end_timeの時、endはstartの翌日であると有効' do
        @study_record.assign_attributes({
          start_time: "08:00",
          end_time: "08:00",
        })
        subject = StudyRecordSerializer.new(@study_record).serializable_hash
        expect(subject[:start]).to eq("2050-05-17 08:00")
        expect(subject[:end]).to eq("2050-05-18 08:00")
      end

    end
  end
end