require 'rails_helper'

RSpec.describe "StudyMaterials", type: :request do

  describe "get" do
    
    context "ログイン済みの場合" do
      before do
        FactoryBot.create(:user)
      end

      it "200 OK を返す" do
        user = { email: "exist_email@test.com", password: "password" }
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
    
  end
end
