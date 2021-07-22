class AddColorToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :color, :string
  end
end
