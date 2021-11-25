FactoryBot.define do
  factory :task_template do
    user { :user }
    study_material { :study_material }
    name { "TaskTemplate" }
    start_date { "2000-01-03" }
    start_time { "2021-05-01 00:00:00" }
    end_time { "2021-05-01 01:00:00" }
    day_of_week { "月" }
    color { "blue" }
    text { "{\"time\":1637831736143,\"blocks\":[{\"id\":\"sHBSl43QZU\",\"type\":\"paragraph\",\"data\":{\"text\":\"test\"}}],\"version\":\"2.22.2\"}" }
  end
end
