class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :study_material, null: false, foreign_key: true
      t.string :name
      t.time :start_time
      t.time :end_time
      t.string :day_of_week

      t.timestamps
    end
  end
end
