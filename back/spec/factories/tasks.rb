FactoryBot.define do
  factory :task do
    association :study_material
    user { study_material.user }
    name { "Task" }
    start_date { "2050-05-17" }
    start_time { "00:00" } 
    end_time { "01:00" }
    color { "bule" }
    text { "{\"time\":1637831736143,\"blocks\":[{\"id\":\"sHBSl43QZU\",\"type\":\"paragraph\",\"data\":{\"text\":\"test\"}}],\"version\":\"2.22.2\"}" }
  end
end
