module Api
  module V1
    class MandalaChartsController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update, :destroy]

      def index
        mandala_charts = current_user.mandala_charts
        render json: mandala_charts, adapter: :json, each_serializer: MandalaChartSerializer, include: { mandala_groups: [:mandala_items] }
      end

      def destroy
        # @mandala_chart.destroy
        if current_user.mandala_charts.length > 1
          @mandala_chart.destroy
        else
          items = @mandala_chart.initItems
        end
        render json: @mandala_chart, adapter: :json, serializer: MandalaChartSerializer, include: { mandala_groups: [:mandala_items] }
      end

      private

      def correct_user
        @mandala_chart = current_user.mandala_charts.find(params[:id])
        redirect_to root_url if @mandala_chart.nil?
      end

    end
  end
end