require 'rails_helper'
module Api
  module V1
    RSpec.describe "TaskSerializer", type: :serializer do
      before do
        @user = FactoryBot.create(:user)
        @study_material = FactoryBot.create(:study_material, user_id: @user.id)
        @task = FactoryBot.create(:task, user_id: @user.id, study_material_id: @study_material.id)
        @subject = TaskSerializer.new(@task).serializable_hash
      end
    
      it 'json で次の属性を返すこと' do
        expect(@subject).to include(:id, :user_id, :study_material_id, :name, :start, :end, :color, :text)
      end

      it 'json で正しい kye と value を返すこと' do
        expect(@subject[:user_id]).to eq(@user.id)
        expect(@subject[:study_material_id]).to eq(@study_material.id)
        expect(@subject[:name]).to eq(@task.name)
        expect(@subject[:start]).to eq("2050-05-17 00:00")
        expect(@subject[:end]).to eq("2050-05-17 01:00")
        expect(@subject[:color]).to eq("bule")
        expect(@subject[:text]).to eq("{\"time\":1637831736143,\"blocks\":[{\"id\":\"sHBSl43QZU\",\"type\":\"paragraph\",\"data\":{\"text\":\"test\"}}],\"version\":\"2.22.2\"}")
      end

      it 'end_time = 00:00 かつ start_time > end_timeの時、endはstartの翌日であると有効' do
        @task.assign_attributes({
          start_time: "23:00",
          end_time: "00:00",
        })
        subject = TaskSerializer.new(@task).serializable_hash
        expect(subject[:start]).to eq("2050-05-17 23:00")
        expect(subject[:end]).to eq("2050-05-18 00:00")
      end

      it 'end_time = 00:00 かつ start_time = end_timeの時、endはstartの翌日であると有効' do
        @task.assign_attributes({
          start_time: "00:00",
          end_time: "00:00",
        })
        subject = TaskSerializer.new(@task).serializable_hash
        expect(subject[:start]).to eq("2050-05-17 00:00")
        expect(subject[:end]).to eq("2050-05-18 00:00")
      end

      it 'end_time ≠ 00:00 かつ start_time > end_timeの時、endはstartの翌日であると有効' do
        @task.assign_attributes({
          start_time: "23:00",
          end_time: "00:15",
        })
        subject = TaskSerializer.new(@task).serializable_hash
        expect(subject[:start]).to eq("2050-05-17 23:00")
        expect(subject[:end]).to eq("2050-05-18 00:15")
      end

      it 'end_time ≠ 00:00 かつ start_time < end_timeの時、endとstartは同じ日付であると有効' do
        @task.assign_attributes({
          start_time: "08:00",
          end_time: "10:00",
        })
        subject = TaskSerializer.new(@task).serializable_hash
        expect(subject[:start]).to eq("2050-05-17 08:00")
        expect(subject[:end]).to eq("2050-05-17 10:00")
      end

      it 'end_time ≠ 00:00 かつ start_time = end_timeの時、endはstartの翌日であると有効' do
        @task.assign_attributes({
          start_time: "08:00",
          end_time: "08:00",
        })
        subject = TaskSerializer.new(@task).serializable_hash
        expect(subject[:start]).to eq("2050-05-17 08:00")
        expect(subject[:end]).to eq("2050-05-18 08:00")
      end

    end

  end
end