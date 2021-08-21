class AddRichTextToStudyNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :study_notes, :rich_text, :text
  end
end
