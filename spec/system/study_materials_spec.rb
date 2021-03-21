require 'rails_helper'

RSpec.describe 'StudyMaterials', js: true, type: :system do
  include ActionDispatch::TestProcess::FixtureFile

  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@test.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@test.com') }

  before do
    FactoryBot.create(
      :study_material,
      name: '最初の教材',
      user: user_a,
      image: fixture_file_upload('app/assets/images/toeic1.jpg')
    )
    visit '/users/sign_in'
    fill_in 'user_email',	with: login_user.email
    fill_in 'user_password',	with: login_user.password
    click_button 'Log in'
  end

  describe '一覧表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      it 'ユーザーAが作成した教材が表示される' do
        visit study_materials_path
        expect(page).to have_content '最初の教材'
      end
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b }
      it 'ユーザーAが作成した教材は表示されない' do
        visit study_materials_path
        expect(page).not_to have_content '最初の教材'
      end
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }
    before do
      visit new_study_material_path
      fill_in 'Name', with: study_material_name
      attach_file('study_material_image', "#{Rails.root}/app/assets/images/toeic2.jpg")
      click_button 'Post'
    end

    context '新規作成画面で有効なデータを送信したとき' do
      let(:study_material_name) { 'user_aが所有する新規教材' }
      it '正常に登録される' do
        visit study_materials_path
        expect(page).to have_content 'user_aが所有する新規教材'
        expect(page).to have_selector("img[src$='toeic2.jpg']")
      end
    end

    context '新規作成画面で無効なデータを送信したとき' do
      let(:study_material_name) { '' }
      it 'name が空でエラーとなる' do
        expect(page).to have_content "can't be blank"
      end
    end
  end

  describe '削除機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }
      it 'ユーザーAが作成した教材を削除できる' do
        visit study_materials_path
        expect do
          page.accept_confirm { click_on 'delete' }
          expect(page).not_to have_content '最初の教材'
        end.to change(user_a.study_materials, :count).by(-1)
      end
    end
  end

  describe '教材の進捗管理機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }
      it 'ユーザーAが作成した教材の進捗を管理できる' do
        visit study_materials_path
        click_button '完了'
        click_button '完了済'
      end
    end
  end
end
