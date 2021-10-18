class AddNoteableToStudyNotes < ActiveRecord::Migration[6.1]
  def change
    add_reference :study_notes, :noteable, polymorphic: true, null: false
  end
end
