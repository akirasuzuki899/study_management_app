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
        @mandala_chart.destroy
        render json: @mandala_chart, adapter: :json, serializer: MandalaChartSerializer
      end

      private

      def study_material_params
        params.permit(:title)
      end

      def correct_user
        @mandala_chart = current_user.mandala_charts.find(params[:id])
        redirect_to root_url if @mandala_chart.nil?
      end

    end
  end
end