class AddTextToTaskTemplates < ActiveRecord::Migration[6.1]
  def change
    add_column :task_templates, :text, :text
  end
end
