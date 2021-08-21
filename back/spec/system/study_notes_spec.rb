# require 'rails_helper'

# RSpec.describe 'StudyNotes', js: true, type: :system do
#   include ActionDispatch::TestProcess::FixtureFile

#   let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@test.com') }
#   let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@test.com') }
#   let(:study_material_a) do
#     FactoryBot.create(
#       :study_material,
#       title: '最初の教材',
#       user: user_a,
#       image: fixture_file_upload('app/assets/images/toeic1.jpg')
#     )
#   end

#   before do
#     FactoryBot.create(
#       :study_note,
#       title: '最初の教材メモ',
#       content: 'rich_text',
#       user: user_a,
#       study_material: study_material_a
#     )
#     visit '/users/sign_in'
#     fill_in 'user_email',	with: login_user.email
#     fill_in 'user_password',	with: login_user.password
#     click_button 'Log in'
#   end

#   describe '一覧表示機能' do
#     context 'ユーザーAがログインしているとき' do
#       let(:login_user) { user_a }

#       it 'ユーザーAが作成した教材メモが表示される' do
#         visit study_notes_path
#         expect(page).to have_content '最初の教材メモ'
#       end
#     end

#     context 'ユーザーBがログインしているとき' do
#       let(:login_user) { user_b }
#       it 'ユーザーAが作成した教材メモは表示されない' do
#         visit study_materials_path
#         expect(page).not_to have_content '最初の教材メモ'
#       end
#     end
#   end

#   describe '新規作成機能' do
#     let(:login_user) { user_a }
#     before do
#       visit new_study_note_path
#       fill_in 'Title', with: study_note_title
#       select study_note_name, from: 'study_note[study_material_id]'
#       fill_in 'Page number', with: 1
#       fill_in_rich_text_area 'study_note_content', with: study_note_content
#       click_button 'Post'
#     end

#     context '新規作成画面で有効なデータを送信したとき' do
#       let(:study_note_title) { 'user_aが所有する新規教材メモ' }
#       let(:study_note_name) { '最初の教材' }
#       let(:study_note_content) { 'rich text' }
#       it '正常に登録される' do
#         visit study_notes_path
#         expect(page).to have_content 'user_aが所有する新規教材メモ'
#       end
#     end

#     context '新規作成画面で無効なデータを送信したとき' do
#       let(:study_note_title) { 'user_aが所有する新規教材メモ' }
#       let(:study_note_name) { '選択して下さい' }
#       let(:study_note_content) { 'rich text' }
#       it 'name が空でエラーとなる' do
#         expect(page).to have_content "can't be blank"
#       end
#     end

#     context '新規作成画面で無効なデータを送信したとき' do
#       let(:study_note_title) { '' }
#       let(:study_note_name) { '最初の教材' }
#       let(:study_note_content) { 'rich text' }
#       it 'title が空でエラーとなる' do
#         expect(page).to have_content "can't be blank"
#       end
#     end

#     context '新規作成画面で無効なデータを送信したとき' do
#       let(:study_note_title) { 'user_aが所有する新規教材メモ' }
#       let(:study_note_name) { '最初の教材' }
#       let(:study_note_content) { '' }
#       it 'content が空でエラーとなる' do
#         expect(page).to have_content "can't be blank"
#       end
#     end
#   end

#   describe '削除機能' do
#     context 'ユーザーAがログインしているとき' do
#       let(:login_user) { user_a }
#       it 'ユーザーAが作成した教材メモを削除できる' do
#         visit study_notes_path
#         expect do
#           page.accept_confirm { click_on 'delete' }
#           expect(page).not_to have_content '最初の教材メモ'
#         end.to change(user_a.study_notes, :count).by(-1)
#       end
#     end

#     context 'ユーザーAが教材Aを削除したとき' do
#       let(:login_user) { user_a }
#       it '教材Aに紐づく教材メモが削除される' do
#         expect do
#           visit study_materials_path
#           expect(page).to have_content '最初の教材'
#           page.accept_confirm { click_on 'delete' }
#           expect(page).not_to have_content '最初の教材'
#           visit study_notes_path
#           expect(page).not_to have_content '最初の教材メモ'
#         end.to change(user_a.study_notes, :count).by(-1)
#       end
#     end
#   end
# end
