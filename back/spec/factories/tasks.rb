FactoryBot.define do
  factory :task do
    user { :user }
    study_material { :study_material }
    name { "Task" }
    start_date { "2050-05-17" }
    start_time { "00:00" } 
    end_time { "01:00" }
    color { "bule" }
  end
end
