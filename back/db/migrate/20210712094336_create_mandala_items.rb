class CreateMandalaItems < ActiveRecord::Migration[6.1]
  def change
    create_table :mandala_items do |t|
      t.references :mandala_group, null: false, foreign_key: true
      t.integer :place_number, null: false
      t.string :text
      t.string :color
      t.boolean :is_finished, default: false, null: false

      t.timestamps
    end
  end
end
