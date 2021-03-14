require 'rails_helper'

RSpec.describe StudyNote, type: :model do
  include ActionDispatch::TestProcess::FixtureFile
  before do
    @user = FactoryBot.create(:user)
    @study_material = FactoryBot.create(:study_material, user_id: @user.id)
    @study_material.picture = fixture_file_upload('app/assets/images/toeic1.jpg')
    @study_note = FactoryBot.build(:study_note, user_id: @user.id, study_material_id: @study_material.id)
  end

  describe '登録' do
    context '有効な投稿' do
      it '有効な user_id, study_material_id, content, title であれば登録できる' do
        expect(@study_note).to be_valid
      end

      it 'title が50文字以下であれば登録できる' do
        @study_note.title = 'a' * 50
        expect(@study_note).to be_valid
      end
    end

    context '無効な投稿' do
      # content のバリデーションが少ない（文字数、画像のサイズ、フォーマットなど未実装）

      it 'ユーザーが存在しない場合は登録できない' do
        @study_note.user_id = nil
        @study_note.valid?
        expect(@study_note.errors[:user_id]).to include("can't be blank")
      end

      it '教材が存在しない場合は登録できない' do
        @study_note.study_material_id = nil
        @study_note.valid?
        expect(@study_note.errors[:study_material_id]).to include("can't be blank")
      end

      it 'title が空であれば登録できない' do
        @study_note.title = nil
        @study_note.valid?
        expect(@study_note.errors[:title]).to include("can't be blank")
      end

      it 'content が空であれば登録できない' do
        @study_note.content = nil
        @study_note.valid?
        expect(@study_note.errors[:content]).to include("can't be blank")
      end

      it 'title が51文字以上であれば登録できない' do
        @study_note.title = 'a' * 51
        @study_note.valid?
        expect(@study_note.errors[:title]).to include('is too long (maximum is 50 characters)')
      end
    end
  end
end
