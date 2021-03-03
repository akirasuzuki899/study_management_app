class CreateStudyNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :study_notes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :study_material, null: false, foreign_key: true
      t.integer :page_number

      t.timestamps
    end
  end
end
