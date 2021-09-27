class RemoveStartDateFromStudyRecords < ActiveRecord::Migration[6.1]
  def change
    remove_column :study_records, :start_date, :date
  end
end
