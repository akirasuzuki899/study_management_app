require 'rails_helper'

RSpec.describe "StudyMaterials", type: :request do
  include ActionDispatch::TestProcess::FixtureFile
  
  let!(:user) { FactoryBot.create(:user) }
  let(:study_material) { FactoryBot.create(:study_material, user: user, title: "test") }
  let(:auth_tokens) { sign_in(email: user.email, password: user.password) }
  before { study_material.attach_rakuten_image("#{Rails.root}/spec/fixtures/files/toeic1.jpeg", study_material.title) }

  describe "get" do
    context "ログイン済みの場合" do
      before { FactoryBot.create(:study_material) }

      it "ユーザーが所有する教材を返す" do
        get "/api/v1/study_materials", headers: auth_tokens
        json = JSON.parse(response.body).deep_symbolize_keys
        
        expect(response).to have_http_status(200)
        expect(json[:study_materials].count).to eq(1)
        expect(json[:study_materials][0][:image_url]).not_to  be_nil
        expect(json[:study_materials][0][:title]).to  eq(study_material.title)
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
    context "ログイン済みの場合" do
      context '全ての属性値が揃っている場合' do
        it '教材を作成できる' do
          expect do
            post '/api/v1/study_materials', 
            params: { title: 'test2', rakuten_image_url: "#{Rails.root}/spec/fixtures/files/toeic1.jpeg" }, 
            headers: auth_tokens
          end.to change(user.study_materials, :count).by(1)
          json = JSON.parse(response.body).deep_symbolize_keys
          expect(response).to have_http_status(200)
          expect(json[:study_material][:image_url]).not_to  be_nil
        end
      end

      context '属性値が無効な時' do
        it '教材を作成しない' do
          expect do
            post '/api/v1/study_materials', 
            params: { title: '', rakuten_image_url: "#{Rails.root}/spec/fixtures/files/toeic1.jpeg" }, 
            headers: auth_tokens
          end.to change(user.study_materials, :count).by(0)
          json = JSON.parse(response.body).deep_symbolize_keys
          expect(response).to have_http_status(400)
          expect(json[:message][:title]).to  include("can't be blank")
        end
      end
    end
  end
end