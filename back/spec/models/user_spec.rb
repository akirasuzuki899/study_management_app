require 'rails_helper'

RSpec.describe User, type: :model do
  describe '新規登録' do
    let!(:user) { FactoryBot.create(:user) }
    let(:new_user) { FactoryBot.build(:new_user) }

    context '有効なユーザー' do
      it '有効な name,email,password であれば登録できる ' do
        expect(new_user).to be_valid
      end

      it 'パスワードが6文字以上であれば登録できる' do
        new_user.password = 'a' * 6
        new_user.password_confirmation = 'a' * 6
        expect(new_user).to be_valid
      end
    end

    context '無効なユーザー' do
      it 'name が空であれば登録できない' do
        new_user.name = nil
        new_user.valid?
        expect(new_user.errors[:name]).to include("can't be blank")
      end

      it 'email が空であれば登録できない' do
        new_user.email = nil
        new_user.valid?
        expect(new_user.errors[:email]).to include("can't be blank")
      end

      it 'password が空であれば登録できない' do
        new_user.password = nil
        new_user.valid?
        expect(new_user.errors[:password]).to include("can't be blank")
      end

      it 'password と password confirmation が一致しない場合登録できない' do
        new_user.password_confirmation = ''
        new_user.valid?
        expect(new_user.errors[:password_confirmation]).to include("doesn't match Password")
      end

      it '登録済みの email で登録できない' do
        new_user.email = 'exist_email@test.com'
        new_user.valid?
        expect(new_user.errors[:email]).to include('has already been taken')
      end

      it 'パスワードが5文字以下だと登録できない' do
        new_user.password = 'a' * 5
        new_user.password_confirmation = 'a' * 5
        new_user.valid?
        expect(new_user.errors[:password]).to include('is too short (minimum is 6 characters)')
      end
    end
  end
end
