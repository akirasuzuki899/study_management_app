class RemoveStudyMaterialIdFromStudyNotes < ActiveRecord::Migration[6.1]
  def change
    remove_column :study_notes, :study_material_id, :bigint
  end
end
