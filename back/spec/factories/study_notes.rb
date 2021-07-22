FactoryBot.define do
  factory :study_note do
    user { :user }
    study_material { :study_material }
    page_number { 1 }
    title { 'title' }
    content { 'content has ritch text' }
  end
end
