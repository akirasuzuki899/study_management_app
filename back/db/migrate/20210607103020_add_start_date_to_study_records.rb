class AddStartDateToStudyRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :study_records, :start_date, :date
  end
end
