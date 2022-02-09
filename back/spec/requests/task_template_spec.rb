require 'rails_helper'

RSpec.describe "StudyMaterials", type: :request do
  
  let!(:user) { task_template.user }
  let(:task_template) { FactoryBot.create(:task_template) }
  let(:auth_tokens) { sign_in(email: user.email, password: user.password) }

  describe "get" do
    context "ログイン済みの場合" do

      it "ユーザーが所有するタスクテンプレートを返す" do
        get "/api/v1/task_templates", headers: auth_tokens
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(response).to have_http_status(200)
        expect(json[:task_templates].count).to eq(1)
      end
    end

    context "未ログインの場合" do
      it "401 を返す" do
        get "/api/v1/task_templates"
        expect(response).to have_http_status(401)
      end
    end

  end

  describe "create" do
    context "ログイン済みの場合" do
      context '全ての属性値が揃っている場合' do
        it 'タスクテンプレートを作成できる' do
          expect do
            post "/api/v1/task_templates", 
            params: FactoryBot.attributes_for(:task_template, user: nil, study_material_id: task_template.study_material.id) , 
            headers: auth_tokens
          end.to change(user.task_templates, :count).by(1)
          expect(response).to have_http_status(200)
        end
      end

      context '属性値が無効な時' do
        it 'タスクテンプレートを作成しない' do
          expect do
            post '/api/v1/task_templates', 
            params: FactoryBot.attributes_for(:task_template, user: nil, study_material_id: nil), 
            headers: auth_tokens
          end.to change(user.task_templates, :count).by(0)
          p response.status
          json = JSON.parse(response.body).deep_symbolize_keys
          expect(response).to have_http_status(400)
          expect(json[:message][:study_material_id]).to  include("can't be blank")
        end
      end
    end
  end

  describe "update" do
    context "ログイン済みの場合" do
      it 'タスクテンプレートを更新できる' do
        expect do
          put "/api/v1/task_templates/#{task_template.id}", 
          params: { name: 'update name' }, 
          headers: auth_tokens
        end.to change(user.task_templates, :count).by(0)
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:task_template][:name]).to  eq("update name")
      end
    end

    context "未ログインの場合" do
      it "401 を返す" do
        put "/api/v1/task_templates/#{task_template.id}", 
        params: { name: 'update title' }
        expect(response).to have_http_status(401)
      end
    end
    
  end
  
  describe "delete" do
    context "ログイン済みの場合" do
      it 'タスクテンプレートを削除できる' do
        expect do
          delete "/api/v1/task_templates/#{task_template.id}", 
          headers: auth_tokens
        end.to change(user.task_templates, :count).by(-1)
      end
    end

    context "未ログインの場合" do
      it "401 を返す" do
        delete "/api/v1/task_templates/#{task_template.id}"
        expect(response).to have_http_status(401)
      end
    end
    
  end
end