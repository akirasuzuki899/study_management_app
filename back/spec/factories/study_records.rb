FactoryBot.define do
  factory :study_record do
    user { :user }
    task { :task }
    study_material { :study_material }
    start_time { "2050-05-17 10:00" }
    end_time { "2050-05-17 11:00" }
    is_finished { false }
  end
end
