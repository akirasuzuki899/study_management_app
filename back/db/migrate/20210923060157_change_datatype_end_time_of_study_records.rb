class ChangeDatatypeEndTimeOfStudyRecords < ActiveRecord::Migration[6.1]
  def change
    change_column :study_records, :end_time, :datetime
  end
end
