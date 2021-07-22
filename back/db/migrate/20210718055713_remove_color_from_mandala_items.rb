class RemoveColorFromMandalaItems < ActiveRecord::Migration[6.1]
  def change
    remove_column :mandala_items, :color, :string
  end
end
