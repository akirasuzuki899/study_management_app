class AddColorToTaskTemplates < ActiveRecord::Migration[6.1]
  def change
    add_column :task_templates, :color, :string
  end
end
