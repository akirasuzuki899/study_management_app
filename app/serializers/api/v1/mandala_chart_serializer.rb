module Api
  module V1
    class MandalaChartSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :title

      has_many :mandala_groups, serializer: MandalaGroupSerializer 
    end
  end
end