FactoryBot.define do
  factory :mandala_item do
    mandala_group { :mandala_group }
    place_number { 1 }
    text { "item text" }
    is_finished { false }
    url { "" }
  end
end