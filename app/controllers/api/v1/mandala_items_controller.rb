module Api
  module V1
    class MandalaItemsController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update]

      def update
        if @mandala_item.update(text: mandala_item_params[:text], is_finished: mandala_item_params[:text])
          if @mandala_item.center_group? && !@mandala_item.center_item? || !@mandala_item.center_group? && @mandala_item.center_item?  
            correspond_item = @mandala_item.get_correspond_item
            correspond_item.update(text: mandala_item_params[:text])
            render  json: {
              mandala_item: ActiveModelSerializers::SerializableResource.new(@mandala_item, serializer: MandalaItemSerializer, include: { mandala_group: [:mandala_chart] }).as_json,
              correspond_item: ActiveModelSerializers::SerializableResource.new(correspond_item, each_serializer: MandalaItemSerializer, include: { mandala_group: [:mandala_chart] }).as_json
            }
          else
            render json: @mandala_item, adapter: :json, each_serializer: MandalaItemSerializer, include: { mandala_group: [:mandala_chart] }
          end

        else
          render json: { status: 'SUCCESS', message: 'Loaded posts', mandala_item: @mandala_item.errors }
        end
      end

      private

      def mandala_item_params
        params.permit(:text, :color, :is_finished, :place_number, :mandala_group_id)
      end

      def correct_user
        @mandala_item = MandalaItem.find(params[:id])
        redirect_to root_url if @mandala_item.nil?
      end
    end
  end
end