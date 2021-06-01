FactoryBot.define do
  factory :study_record do
    user { nil }
    task { nil }
    study_material { nil }
    start_time { "2021-06-01 16:43:00" }
    end_time { "2021-06-01 16:43:00" }
    is_finished { false }
  end
end
