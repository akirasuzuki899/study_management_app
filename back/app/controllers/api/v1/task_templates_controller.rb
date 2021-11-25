module Api
  module V1
    class TaskTemplatesController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update, :destroy]

      def index
        @task_templates = current_user.task_templates
        render json: @task_templates, adapter: :json, each_serializer: TaskTemplateSerializer
      end

      def create
        @task_template = current_user.task_templates.build(task_template_params)
        if @task_template.save
          render json: @task_template, adapter: :json, serializer: TaskTemplateSerializer
        else
          render json: { status: 'SUCCESS', message: 'Loaded posts', task_template: @task_template.errors }
        end
      end

      def update
        if @task_template.update(task_template_params)
          render json: @task_template, adapter: :json, serializer: TaskTemplateSerializer
        else
          render json: { status: 'SUCCESS', message: 'Loaded posts', task_template: @task_template.errors }
        end
      end

      def destroy
        @task_template.destroy
        render json: @task_template, adapter: :json, serializer: TaskTemplateSerializer
      end

      private

      def task_template_params
        params.permit(:study_material_id, :name, :start_date, :start_time, :end_time, :color, :text)
      end

      def correct_user
        @task_template = current_user.task_templates.find(params[:id])
        redirect_to root_url if @task_template.nil?
      end

    end
  end
end
