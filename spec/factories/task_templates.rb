FactoryBot.define do
  factory :task_template do
    user { :user }
    study_material { :study_material }
    name { "TaskTemplate" }
    start_time { "2021-05-01 00:00:00" }
    end_time { "2021-05-01 01:00:00" }
    day_of_week { "月" }
  end
end
