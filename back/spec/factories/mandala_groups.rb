FactoryBot.define do
  factory :mandala_group do
    association :mandala_chart
    place_number { 1 }
  end
end
