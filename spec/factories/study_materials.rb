FactoryBot.define do
  factory :study_material do
    association :user, factory: :user
    title { 'study_material_title' }
    is_completed { false }
  end
end
