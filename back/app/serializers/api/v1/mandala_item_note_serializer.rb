module Api
  module V1
    class MandalaItemNoteSerializer < ActiveModel::Serializer
      attributes :id, :mandala_chart_id, :place_number , :children, :title

      def children
          children = object.mandala_items.map { |item| 
            {
              id: item.id,
              mandala_group_id: item.mandala_group_id,
              mandala_group: {
                place_number: object.place_number,
              },
              place_number: item.place_number,
              title: item.text,
              children: item.study_notes
            }
          }
      end

      def title
        item = object.mandala_items.find_by(place_number: 5)
        item.text
      end

    end
  end
end