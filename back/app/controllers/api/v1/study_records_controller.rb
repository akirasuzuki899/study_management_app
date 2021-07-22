module Api
  module V1
    class StudyRecordsController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update]

      def index
        study_records = current_user.study_records
        render json: study_records, adapter: :json, each_serializer: StudyRecordSerializer
      end

      def create

      end

      def update
        if @study_record.update(study_record_params)
          render json: @study_record, adapter: :json, serializer: StudyRecordSerializer
        else
          render json: { status: 'SUCCESS', message: 'Loaded posts', task: @study_record.errors }
        end
      end

      private

      def study_record_params
        params.permit(:task_id, :study_material_id, :start_date, :start_time, :end_time, :is_finished )
      end

      def correct_user
        @study_record = current_user.study_records.find(params[:id])
        redirect_to root_url if @study_record.nil?
      end

    end
  end
end