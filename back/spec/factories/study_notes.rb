FactoryBot.define do
  factory :study_material_note, class: 'StudyNote' do
    association :user, factory: :user
    association :noteable, factory: :study_material
    noteable_type { 'StudyMaterial' } 
    title { 'title' }
    rich_text { 'content has ritch text' }
  end
  factory :mandala_item_note, class: 'StudyNote' do
    association :user, factory: :user
    association :noteable, factory: :mandala_item 
    noteable_type { 'MandalaItem' } 
    title { 'title' }
    rich_text { 'content has ritch text' }
  end
end