class RemoveTitleFromMandalaCharts < ActiveRecord::Migration[6.1]
  def change
    remove_column :mandala_charts, :title, :text
  end
end
