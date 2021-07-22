class RemoveEndDateFromTasks < ActiveRecord::Migration[6.1]
  def change
    remove_column :tasks, :end_date, :date
  end
end
