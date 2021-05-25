FactoryBot.define do
  factory :task do
    user { :user }
    study_material { :study_material }
    name { "Task" }
    start_at { "2050-05-17 00:00:00" }
    end_at { "2050-05-17 01:00:00" }
    start_date { "2050-05-17" }
    start_time { "00:00" } 
    end_date { "2050-05-17" }
    end_time { "01:00" }
  end
end
