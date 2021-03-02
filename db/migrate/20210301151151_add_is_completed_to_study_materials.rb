class AddIsCompletedToStudyMaterials < ActiveRecord::Migration[6.1]
  def change
    add_column :study_materials, :is_completed, :boolean, default: false, null: false
  end
end
