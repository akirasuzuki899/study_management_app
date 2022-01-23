require 'rails_helper'

RSpec.describe StudyNote, type: :model do
  include ActionDispatch::TestProcess::FixtureFile

  let(:study_material_note) { FactoryBot.create(:study_material_note) }
  let(:mandala_item_note) { FactoryBot.create(:mandala_item_note) }

  describe '教材のノート作成' do
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

  describe 'マンダラチャートのノート作成' do
    context '有効な投稿' do
      it 'user_id, noteable_id, noteable_type, title, rich_text が存在すれば有効' do
        expect(mandala_item_note).to  be_valid
      end

      it 'title が50文字以下であれば登録できる' do
        mandala_item_note.title = 'a' *50
        expect(mandala_item_note).to  be_valid
      end
    end

    context '無効な投稿' do
      it 'ユーザーが存在しない場合は登録できない' do
        mandala_item_note.user_id = ''
        mandala_item_note.valid?
        expect(mandala_item_note.errors[:user_id]).to include("can't be blank")
      end

      it 'title が空であれば登録できない' do
        mandala_item_note.title = ''
        mandala_item_note.valid?
        expect(mandala_item_note.errors[:title]).to include("can't be blank")
      end

      it 'title が51文字以上であれば登録できない' do
        mandala_item_note.title = 'a' * 51
        mandala_item_note.valid?
        expect(mandala_item_note.errors[:title]).to include('is too long (maximum is 50 characters)')
      end

      it 'noteable_id が空であれば登録できない' do
        mandala_item_note.noteable_id = ''
        mandala_item_note.valid?
        expect(mandala_item_note.errors[:noteable_id]).to include("can't be blank")
      end

      it 'noteable_type が空であれば登録できない' do
        mandala_item_note.noteable_type = ''
        mandala_item_note.valid?
        expect(mandala_item_note.errors[:noteable_type]).to include("can't be blank")
      end
    end
  end
end
