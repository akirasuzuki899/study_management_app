class AddStartDateToTaskTemplates < ActiveRecord::Migration[6.1]
  def change
    add_column :task_templates, :start_date, :date
  end
end
