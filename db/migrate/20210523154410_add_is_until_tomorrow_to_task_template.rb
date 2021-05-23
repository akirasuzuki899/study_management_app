class AddIsUntilTomorrowToTaskTemplate < ActiveRecord::Migration[6.1]
  def change
    add_column :task_templates, :is_until_tomorrow, :boolean, default: false, null: false
  end
end
