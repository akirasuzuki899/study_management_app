FactoryBot.define do
  factory :task do
    user { nil }
    study_material { nil }
    name { "MyString" }
    start_time { "2021-05-17 14:51:55" }
    end_time { "2021-05-17 14:51:55" }
    day_of_week { "MyString" }
  end
end
