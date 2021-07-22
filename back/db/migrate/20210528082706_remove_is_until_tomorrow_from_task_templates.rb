class RemoveIsUntilTomorrowFromTaskTemplates < ActiveRecord::Migration[6.1]
  def change
    remove_column :task_templates, :is_until_tomorrow, :boolean
  end
end
