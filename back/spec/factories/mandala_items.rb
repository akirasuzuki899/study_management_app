FactoryBot.define do
  factory :mandala_item do
    association :mandala_group
    place_number { 1 }
    text { "item text" }
    is_finished { false }
    url { "" }
  end
end
