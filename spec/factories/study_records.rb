FactoryBot.define do
  factory :study_record do
    user { :user }
    task { :task }
    study_material { :study_material }
    start_date { "2050-05-17" }
    start_time { "10:00" }
    end_time { "11:00" }
    is_finished { false }
  end
end
