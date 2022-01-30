require 'rails_helper'

RSpec.describe "StudyMaterials", type: :request do
  
  let!(:user) { study_material_note.user }
  let(:study_material_note) { FactoryBot.create(:study_material_note, title: "test") }
  let(:auth_tokens) { sign_in(email: user.email, password: user.password) }

  describe "get" do
    context "ログイン済みの場合" do

      it "ユーザーが所有するノートを返す" do
        get "/api/v1/study_materials/study_notes", headers: auth_tokens
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(response).to have_http_status(200)
        expect(json[:tree_view].count).to eq(1)                    #教材の数
        expect(json[:tree_view][0][:children].count).to  eq 1      #教材のノートの数
        expect(json[:tree_view][0][:children][0][:title]).to  eq(study_material_note.title)
      end
    end

    context "未ログインの場合" do
      it "401 を返す" do
        get "/api/v1/study_materials/study_notes"
        expect(response).to have_http_status(401)
      end
    end

  end

  describe "create" do
    context "ログイン済みの場合" do
      context '全ての属性値が揃っている場合' do
        it 'ノートを作成できる' do
          study_material_id = study_material_note.noteable.id
          expect do
            post "/api/v1/study_materials/#{study_material_id}/study_notes", 
            params: { study_note: { title: 'test2', rich_text: study_material_note.rich_text }}, 
            headers: auth_tokens
          end.to change(user.study_notes, :count).by(1)
          expect(response).to have_http_status(200)
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

  describe "update" do
    context "ログイン済みの場合" do
      it 'ノートを削除できる' do
        expect do
          put "/api/v1/study_notes/#{study_material_note.id}", 
          params: { study_note: { title: 'update title'}}, 
          headers: auth_tokens
        end.to change(user.study_notes, :count).by(0)
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:study_note][:title]).to  eq("update title")
      end
    end

    context "未ログインの場合" do
      it "401 を返す" do
        put "/api/v1/study_notes/#{study_material_note.id}", 
        params: { study_note: { title: 'update title'}}
        expect(response).to have_http_status(401)
      end
    end
    
  end
  
  describe "delete" do
    context "ログイン済みの場合" do
      it 'ノートを削除できる' do
        expect do
          delete "/api/v1/study_notes/#{study_material_note.id}", 
          headers: auth_tokens
        end.to change(user.study_notes, :count).by(-1)
      end
    end

    context "未ログインの場合" do
      it "401 を返す" do
        delete "/api/v1/study_notes/#{study_material_note.id}"
        expect(response).to have_http_status(401)
      end
    end
    
  end
end