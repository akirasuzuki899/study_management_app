FactoryBot.define do
  factory :new_user, class: User do
    name { 'newUser' }
    email { 'new_email@test.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :user, class: User do
    name { 'existUser' }
    email { 'exist_email@test.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
