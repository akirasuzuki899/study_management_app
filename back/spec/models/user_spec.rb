require 'rails_helper'

RSpec.describe User, type: :model do
  describe '新規登録' do
    let(:user) { FactoryBot.build(:user) }

    context '有効なユーザー' do
      it '有効な name,email,password であれば登録できる ' do
        expect(user).to be_valid
      end

      it 'パスワードが6文字以上であれば登録できる' do
        user.password = 'a' * 6
        user.password_confirmation = 'a' * 6
        expect(user).to be_valid
      end

      it 'ユーザーが所有する mandala_chart, mandala_group, mandala_item を作成する' do
        user.save
        expect(user.mandala_charts.count).to  be 1
        expect(user.mandala_charts[0].mandala_groups.count).to  be 9
        expect(user.mandala_charts[0].mandala_groups[0].mandala_items.count).to  be 9
      end
    end

    context '無効なユーザー' do
      it 'name が空であれば登録できない' do
        user.name = nil
        user.valid?
        expect(user.errors[:name]).to include("can't be blank")
      end

      it 'email が空であれば登録できない' do
        user.email = nil
        user.valid?
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'password が空であれば登録できない' do
        user.password = nil
        user.valid?
        expect(user.errors[:password]).to include("can't be blank")
      end

      it 'password と password confirmation が一致しない場合登録できない' do
        user.password_confirmation = ''
        user.valid?
        expect(user.errors[:password_confirmation]).to include("doesn't match Password")
      end

      it '登録済みの email で登録できない' do
        FactoryBot.create(:user, email: "test@example.com")
        new_user = FactoryBot.build(:user, email: "test@example.com")
        new_user.valid?
        expect(new_user.errors[:email]).to include('has already been taken')
      end

      it 'パスワードが5文字以下だと登録できない' do
        user.password = 'a' * 5
        user.password_confirmation = 'a' * 5
        user.valid?
        expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
      end

      it 'mandala_chart を作成しない' do
        expect(user.mandala_charts.count).to  be 0
      end
    end
    
  end
end
