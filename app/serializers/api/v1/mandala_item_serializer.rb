module Api
  module V1
    class MandalaItemSerializer < ActiveModel::Serializer
      attributes :id, :mandala_group_id, :place_number, :text, :color, :is_finished

    end
  end
end