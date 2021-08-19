FactoryBot.define do
  factory :study_note do
    user { :user }
    study_material { :study_material }
    title { 'title' }
    content { 'content has ritch text' }
  end
end