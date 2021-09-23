class ChangeDatatypeStartTimeOfStudyRecords < ActiveRecord::Migration[6.1]
  def change
    change_column :study_records, :start_time, :datetime
  end
end
