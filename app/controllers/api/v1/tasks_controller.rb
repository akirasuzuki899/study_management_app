module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update, :destroy]

      def index
        today = Time.now
        @tasks = current_user.tasks.where(start_date: today.beginning_of_week..today.end_of_week)
        render json: @tasks, adapter: :json, each_serializer: TaskSerializer
      end

      def create
        task = current_user.tasks.build(task_params)
        if task.save
          render json: task, adapter: :json, serializer: TaskSerializer
        else
          render json: {
            status: 400,
            task: task.errors
          }
        end
      end

      def update
        if @task.update(task_params)
          render json: @task, adapter: :json, serializer: TaskSerializer
        else
          render json: { status: 'SUCCESS', message: 'Loaded posts', task: @task.error }
        end
      end

      def destroy
        @task.destroy
        render json: @task, adapter: :json, serializer: TaskSerializer
      end

      private

      def task_params
        params.permit(:study_material_id, :name, :start_date, :start_time, :end_time)
      end

      def correct_user
        @task = current_user.tasks.find(params[:id])
        redirect_to root_url if @task.nil?
      end

    end
  end
end

