class ScheduleTemplate < ApplicationRecord
  belongs_to :user
  belongs_to :study_material
end
