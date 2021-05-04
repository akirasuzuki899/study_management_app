class RenameTitleColumnToScheduleTemplates < ActiveRecord::Migration[6.1]
  def change
    rename_column :schedule_templates, :title, :name
  end
end
