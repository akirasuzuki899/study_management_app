module Api
  module V1
    class StudyRecordsController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update]

      def index
        study_records = current_user.study_records
        render json: study_records
      end

      def create

      end

      def update

      end

      private

      def correct_user
        @study_record = current_user.study_records.find(params[:id])
        redirect_to root_url if @study_record.nil?
      end

    end
  end
end