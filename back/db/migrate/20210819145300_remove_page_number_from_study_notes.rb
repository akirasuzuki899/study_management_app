class RemovePageNumberFromStudyNotes < ActiveRecord::Migration[6.1]
  def change
    remove_column :study_notes, :page_number, :integer
  end
end
