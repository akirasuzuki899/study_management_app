require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "register" do

    context '全てのパラメータが揃っている場合' do
      it '200 OK を返す' do
        post '/api/v1/auth', params: { email: 'test@test.com', password: 'password', name: 'test' }, headers: { 'ACCEPT' => 'application/json' }
        expect(response).to have_http_status(200)
      end

      it 'ユーザを登録する' do
        expect do
          post '/api/v1/auth', params: { email: 'test@test.com', password: 'password', name: 'test' }, headers: { 'ACCEPT' => 'application/json' }
        end.to change(User, :count).by(1)
      end
    end

    context 'emailが既に登録されている場合' do
      before { FactoryBot.create(:user) }
      
      it '422 unprocessable_entity を返す' do
        post '/api/v1/auth', params: { email: 'exist_email@test.com', password: 'password', name: 'test' }, headers: { 'ACCEPT' => 'application/json' }
        expect(response).to have_http_status(422)
      end

      it 'ユーザを登録しない' do
        expect do
          post '/api/v1/auth', params: { email: 'exist_email@test.com', password: 'password', name: 'test' }, headers: { 'ACCEPT' => 'application/json' }
        end.to change(User, :count).by(0)
      end
    end

  end

  describe "login" do

    before { FactoryBot.create(:user) }

    context '全てのパラメータが揃っている場合' do
      it '200 OK を返す' do
        post '/api/v1/auth/sign_in', params: { email: 'exist_email@test.com', password: 'password' }, headers: { 'ACCEPT' => 'application/json' }
        expect(response).to have_http_status(200)
      end
    end

    context 'password が異なる場合' do
      it '401 unauthorized を返す' do
        post '/api/v1/auth/sign_in', params: { email: 'exist_email@test.com', password: 'tttttt' }, headers: { 'ACCEPT' => 'application/json' }
        expect(response).to have_http_status(401)
      end
    end

    context '登録されていない email の場合' do
      it '401 unauthorized を返す' do
        post '/api/v1/auth/sign_in', params: { email: 'un_exist_email@test.com', password: 'password' }, headers: { 'ACCEPT' => 'application/json' }
        expect(response).to have_http_status(401)
      end
    end
    
  end
end