module Api
  module V1
    class MandalaItemNoteSerializer < ActiveModel::Serializer
      attributes :id, :mandala_chart_id, :children, :text

      def children
          children = object.mandala_items.map { |item| 
            {
              id: item.id,
              text: item.text,
              children: item.study_notes
            }
          }
      end

      def text
        item = object.mandala_items.find_by(place_number: 5)
        item.text
      end
      
    end
  end
end