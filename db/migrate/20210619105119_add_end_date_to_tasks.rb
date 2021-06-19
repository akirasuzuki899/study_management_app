class AddEndDateToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :end_date, :date
  end
end
