FactoryBot.define do
  factory :study_material do
    association :user, factory: :user
    sequence(:title) { |n| "study_material_title#{n}" }
    is_completed { false }
  end
end
