class ChangeScheduleTemplatesToTaskTemplates < ActiveRecord::Migration[6.1]
  def change
    rename_table :schedule_templates, :task_templates
  end
end
