module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update, :destroy]

      def index
        today = Date.today
        tasks = current_user.tasks.where(start_date: today.beginning_of_week..today.end_of_week)
        unfinished_tasks = current_user.tasks.left_joins(:study_record)
          .where('end_date < ? ', today)
          .where(study_record: {is_finished: false})
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

      def create_from_tesk_templates
        today = %w(日 月 火 水 木 金 土)[Date.today.wday]
        from = TaskTemplate::BASEWEEK[today].to_date
        to = TaskTemplate::BASEWEEK["日"].to_date
        task_templates = current_user.task_templates.where(start_date: from..to)
        tasks = Task.create_this_week_tasks_from_templates(task_templates)
        if tasks.present?
          render json: tasks, adapter: :json, each_serializer: TaskSerializer
        else
          render json: { status: 400, task: tasks }   #バリデーションエラー時の処理を追加する
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