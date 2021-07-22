class CreateMandalaGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :mandala_groups do |t|
      t.references :mandala_chart, null: false, foreign_key: true
      t.integer :place_number, null: false

      t.timestamps
    end
  end
end
