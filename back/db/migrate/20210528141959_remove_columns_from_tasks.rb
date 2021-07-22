class RemoveColumnsFromTasks < ActiveRecord::Migration[6.1]
  def change
    remove_column :tasks, :start_at, :datetime
    remove_column :tasks, :end_at, :datetime
  end
end
