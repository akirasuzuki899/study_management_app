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
        expect(@subject).to include(:id, :user_id, :study_material_id, :name, :start, :end, :start_date, :end_date, :start_time, :end_time)
      end

      it 'json で正しい kye と value を返すこと' do
        expect(@subject[:user_id]).to eq(@user.id)
        expect(@subject[:study_material_id]).to eq(@study_material.id)
        expect(@subject[:name]).to eq(@task.name)
        expect(@subject[:start]).to eq("2050-05-17 00:00")
        expect(@subject[:end]).to eq("2050-05-17 01:00")
        expect(@subject[:start_date]).to eq("2050-05-17")
        expect(@subject[:end_date]).to eq("2050-05-17")
        expect(@subject[:start_time]).to eq("00:00")
        expect(@subject[:end_time]).to eq("01:00")
      end
    end

  end
end