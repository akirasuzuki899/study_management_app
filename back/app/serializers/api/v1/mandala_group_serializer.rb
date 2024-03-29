module Api
  module V1
    class MandalaGroupSerializer < ActiveModel::Serializer
      attributes :id, :mandala_chart_id, :place_number

      belongs_to :mandala_chart
      has_many :mandala_items, serializer: MandalaItemSerializer
    end
  end
end