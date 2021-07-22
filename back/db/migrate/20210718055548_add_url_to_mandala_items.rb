class AddUrlToMandalaItems < ActiveRecord::Migration[6.1]
  def change
    add_column :mandala_items, :url, :text
  end
end
