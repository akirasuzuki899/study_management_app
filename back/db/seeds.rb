# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
5.times do |n|
  User.create!(
    email: "test#{n + 1}@test.com",
    name: "ユーザー#{n + 1}",
    password: 'password'
  )
end

users = User.order(:created_at).all
users.each do |user|
  # 教材を追加
  7.times do |n|
    study_material = user.study_materials.create!(
      title: "公式TOEIC Listning & Reading 問題集 #{n + 1}",
      is_completed: false
    )
    study_material.image.attach(io: File.open(Rails.root.join("./app/assets/images/toeic#{n + 1}.jpg")), filename: "toeic#{n + 1}.jpg")
  end

  # 教材のメモを追加
  study_materials = user.study_materials
  5.times do |n|
    study_note = user.study_notes.create!(
      study_material_id: study_materials[n].id.to_s,
      title: "タイトル#{n + 1}",
      content: "<p>テキスト#{n + 1}</p>"
    )
  end
end
