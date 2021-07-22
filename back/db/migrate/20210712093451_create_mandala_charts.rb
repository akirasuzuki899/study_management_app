class CreateMandalaCharts < ActiveRecord::Migration[6.1]
  def change
    create_table :mandala_charts do |t|
      t.references :user, null: false, foreign_key: true
      t.text :title

      t.timestamps
    end
  end
end
