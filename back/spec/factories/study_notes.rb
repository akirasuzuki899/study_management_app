FactoryBot.define do
  factory :study_material_note, class: 'StudyNote' do
    association :noteable, factory: :study_material
    user { noteable.user }
    noteable_type { 'StudyMaterial' } 
    title { 'title' }
    rich_text { "{\"time\":1637831736143,\"blocks\":[{\"id\":\"sHBSl43QZU\",\"type\":\"paragraph\",\"data\":{\"text\":\"test\"}}],\"version\":\"2.22.2\"}" }
  end
  factory :mandala_item_note, class: 'StudyNote' do
    association :noteable, factory: :mandala_item 
    user { noteable.mandala_group.mandala_chart.user }
    noteable_type { 'MandalaItem' } 
    title { 'title' }
    rich_text { "{\"time\":1637831736143,\"blocks\":[{\"id\":\"sHBSl43QZU\",\"type\":\"paragraph\",\"data\":{\"text\":\"test\"}}],\"version\":\"2.22.2\"}" }
  end
end