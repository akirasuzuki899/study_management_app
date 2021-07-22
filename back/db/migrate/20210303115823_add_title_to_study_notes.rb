class AddTitleToStudyNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :study_notes, :title, :string
  end
end
