# require 'rails_helper'

# RSpec.describe StudyMaterial, type: :model do
#   include ActionDispatch::TestProcess::FixtureFile

#   before do
#     @user = FactoryBot.create(:user)
#     @study_material = FactoryBot.build(:study_material, user_id: @user.id)
#     @study_material.image = fixture_file_upload('app/assets/images/toeic1.jpg')
#   end

#   describe '登録' do
#     context '有効な投稿' do
#       it '有効な user_id,title,image であれば登録できる' do
#         expect(@study_material).to be_valid
#       end

#       it 'title が100文字以下であれば登録できる' do
#         @study_material.title = 'a' * 100
#         expect(@study_material).to be_valid
#       end
#     end

#     context '無効な投稿' do
#       画像のサイズとフォーマットのテストが未実装

#       it 'ユーザーが存在しない場合は登録できない' do
#         @study_material.user_id = ''
#         @study_material.valid?
#         expect(@study_material.errors[:user_id]).to include("can't be blank")
#       end

#       it 'title が空であれば登録できない' do
#         @study_material.title = ''
#         @study_material.valid?
#         expect(@study_material.errors[:title]).to include("can't be blank")
#       end

#       it 'title が101文字以上であれば登録できない' do
#         @study_material.title = 'a' * 101
#         @study_material.valid?
#         expect(@study_material.errors[:title]).to include('is too long (maximum is 100 characters)')
#       end
#     end
#   end
# end