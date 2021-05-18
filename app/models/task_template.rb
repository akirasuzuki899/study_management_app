class TaskTemplate < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :study_material

end
