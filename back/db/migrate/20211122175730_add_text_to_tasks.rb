class AddTextToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :text, :text
  end
end
