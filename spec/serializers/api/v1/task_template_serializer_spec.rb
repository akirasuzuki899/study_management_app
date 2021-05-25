require 'rails_helper'

module Api
  module V1
    RSpec.describe "TaskTemplateSerializer", type: :serializer do
      before do
        @user = FactoryBot.create(:user)
        @study_material = FactoryBot.create(:study_material, user_id: @user.id)
        @task_template = FactoryBot.create(:task_template, user_id: @user.id, study_material_id: @study_material.id)
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

      it '属性値start,endは曜日に対して特定の日付( 2000-01-03 ~ 2000-01-09 )に決まること'

      it 'start_time,end_timeの属性値が0時をまたぐ時、endの値はstartの一日後であること'
    end

  end
end