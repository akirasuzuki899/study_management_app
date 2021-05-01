FactoryBot.define do
  factory :schedule_template do
    user { nil }
    study_material { nil }
    title { "MyString" }
    start_time { "2021-05-01 14:52:10" }
    end_time { "2021-05-01 14:52:10" }
    day_of_week { "MyString" }
  end
end
