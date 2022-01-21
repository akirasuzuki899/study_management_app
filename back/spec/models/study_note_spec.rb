require 'rails_helper'

RSpec.describe StudyNote, type: :model do
  include ActionDispatch::TestProcess::FixtureFile
  let(:user) { FactoryBot.create(:user) }
  let(:study_material) { FactoryBot.create(:study_material, user_id: user.id) }
  let(:study_material_note) { FactoryBot.create(:study_material_note, user_id: user.id, noteable_id: study_material.id) }


  describe '作成' do
    context '有効な投稿' do
      it 'user_id, noteable_id, noteable_type, title, rich_text が存在すれば有効' do
        expect(study_material_note).to  be_valid
      end

      it 'title が50文字以下であれば登録できる' do
        study_material_note.title = 'a' *50
        expect(study_material_note).to  be_valid
      end
    end

    context '無効な投稿' do
      it 'ユーザーが存在しない場合は登録できない' do
        study_material_note.user_id = ''
        study_material_note.valid?
        expect(study_material_note.errors[:user_id]).to include("can't be blank")
      end

      it 'title が空であれば登録できない' do
        study_material_note.title = ''
        study_material_note.valid?
        expect(study_material_note.errors[:title]).to include("can't be blank")
      end

      it 'title が51文字以上であれば登録できない' do
        study_material_note.title = 'a' * 51
        study_material_note.valid?
        expect(study_material_note.errors[:title]).to include('is too long (maximum is 50 characters)')
      end

      it 'noteable_id が空であれば登録できない' do
        study_material_note.noteable_id = ''
        study_material_note.valid?
        expect(study_material_note.errors[:noteable_id]).to include("can't be blank")
      end

      it 'noteable_type が空であれば登録できない' do
        study_material_note.noteable_type = ''
        study_material_note.valid?
        expect(study_material_note.errors[:noteable_type]).to include("can't be blank")
      end
    end
  end
end
