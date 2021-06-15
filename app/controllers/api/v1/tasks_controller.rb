module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update, :destroy]

      def index
        today = Time.now
        tasks = current_user.tasks.where(start_date: today.beginning_of_week..today.end_of_week)
        unfinished_tasks = current_user.tasks.left_joins(:study_record).where(study_record: {is_finished: false} )
        render  json: {
          tasks: ActiveModelSerializers::SerializableResource.new(tasks, each_serializer: TaskSerializer).as_json,
          unfinished_tasks: ActiveModelSerializers::SerializableResource.new(unfinished_tasks, each_serializer: TaskSerializer).as_json
        }
      end

      def create
        task = current_user.tasks.build(task_params)
        if task.save
          study_record = set_study_record(task)
          study_record.save(validate: false)
          render json: task, adapter: :json, serializer: TaskSerializer      
        else
          render json: { status: 400, task: task.errors }
        end
      end

      def update
        if @task.update(task_params)
          render json: @task, adapter: :json, serializer: TaskSerializer
        else
          render json: { status: 'SUCCESS', message: 'Loaded posts', task: @task.errors }
        end
      end

      def destroy
        @task.destroy
        render json: @task, adapter: :json, serializer: TaskSerializer
      end

      private

      def task_params
        params.permit(:study_material_id, :name, :start_date, :start_time, :end_time, :color)
      end

      def correct_user
        @task = current_user.tasks.find(params[:id])
        redirect_to root_url if @task.nil?
      end

      def set_study_record(task)
        StudyRecord.new(
          user_id: task.user_id,
          task_id: task.id,
          study_material_id: task.study_material_id,
        )
      end

    end
  end
end

