require 'rails_helper'

RSpec.describe "StudyMaterials", type: :request do

  describe "get" do
    context "ログイン済みの場合" do

      before { FactoryBot.create(:user, email: 'test@example.com') }

      it "200 OK を返す" do
        user = { email: "test@example.com", password: "password" }
        auth_tokens = sign_in(user)
        get "/api/v1/study_materials", headers: auth_tokens
        expect(response).to have_http_status(200)
      end
    end

    context "未ログインの場合" do
      it "401 を返す" do
        get "/api/v1/study_materials"
        expect(response).to have_http_status(401)
      end
    end

  end

  describe "create" do
    context '全てのパラメータが揃っている場合' do

      before { user = FactoryBot.create(:user, email: 'test@example.com') }
      
      it '200 OK を返す' do
        user = { email: "test@example.com", password: "password" }
        auth_tokens = sign_in(user)
        post '/api/v1/study_materials', params: { title: 'test', rakuten_image_url: "#{Rails.root}/spec/fixtures/files/toeic1.jpeg" }, headers: auth_tokens
        expect(response).to have_http_status(200)
      end
      
      it '教材を登録する' do
        user = { email: "test@example.com", password: "password" }
        auth_tokens = sign_in(user)
        expect do
          post '/api/v1/study_materials', params: { title: 'test', rakuten_image_url: "#{Rails.root}/spec/fixtures/files/toeic1.jpeg" }, headers: auth_tokens
        end.to change(StudyMaterial, :count).by(1)
      end
    end
  end
end