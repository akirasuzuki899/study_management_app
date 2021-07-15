module Api
  module V1
    class MandalaItemSerializer < ActiveModel::Serializer
      attributes :id, :mandala_group_id, :place_number, :text, :color, :is_finished

      belongs_to :mandala_group
    end
  end
end