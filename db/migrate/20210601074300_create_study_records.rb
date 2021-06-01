class CreateStudyRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :study_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.references :study_material, null: false, foreign_key: true
      t.time :start_time
      t.time :end_time
      t.boolean :is_finished, default: false, null: false

      t.timestamps
    end
  end
end
