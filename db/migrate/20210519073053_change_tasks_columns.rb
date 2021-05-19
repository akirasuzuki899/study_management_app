class ChangeTasksColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :tasks, :start_time, :time
    remove_column :tasks, :end_time, :time
    remove_column :tasks, :day_of_week, :string
    add_column :tasks, :start_at, :datetime
    add_column :tasks, :end_at, :datetime
  end
end
