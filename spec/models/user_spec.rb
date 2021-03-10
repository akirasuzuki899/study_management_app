require 'rails_helper'

RSpec.describe User, type: :model do
  it "有効な name,email,password であれば登録できる " do
    user = User.new(
      name:       "user",
      email:      "test@test.com",
      password:   "password",
    )
    expect(user).to be_valid
  end

  it "name が空であれば登録できない" do
    user = User.new(name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "email が空であれば登録できない" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "password が空であれば登録できない" do
    user = User.new(password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "password と password confirmation が一致しない場合登録できない" do
    user = User.new(password_confirmation: nil)
    user.valid?
    expect(user.errors[:password_confirmation]).to include("doesn't match Password")
  end

  it "登録済みの email で登録できない" do
    User.create(
      name:  "test1",
      email:      "test@example.com",
      password:   "password",
    )
    user = User.new(
      name:  "test2",
      email:      "test@example.com",
      password:   "password",
    )
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "パスワードが6文字以上であれば登録できる" do
    user = User.new(
      name:  "test2",
      email:      "test@example.com",
      password:   "a"*6,
    )
    expect(user).to be_valid
  end

  it "パスワードが5文字以下だと登録できない" do
    user = User.new(
      name:  "test2",
      email:      "test@example.com",
      password:   "a"*5,
    )
    user.valid?
    expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
  end
end
