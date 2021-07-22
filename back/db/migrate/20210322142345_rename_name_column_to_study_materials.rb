class RenameNameColumnToStudyMaterials < ActiveRecord::Migration[6.1]
  def change
    rename_column :study_materials, :name, :title
  end
end
