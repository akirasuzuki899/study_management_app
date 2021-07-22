class CreateStudyMaterials < ActiveRecord::Migration[6.1]
  def change
    create_table :study_materials do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
