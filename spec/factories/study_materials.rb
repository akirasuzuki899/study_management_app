FactoryBot.define do
  factory :study_material do
    association :user, factory: :user
    name { "study_material_name" }
    is_completed { false }
  end
end
