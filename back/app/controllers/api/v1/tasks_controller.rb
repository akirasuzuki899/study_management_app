module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update, :destroy]

      def index
        today = Date.today
        tasks = current_user.tasks.where(start_date: today.beginning_of_week..today.end_of_week)
            .or(current_user.tasks.where(end_date: today.beginning_of_week))
        render json: tasks, adapter: :json, each_serializer: TaskSerializer
      end

      def create
        task = current_user.tasks.build(task_params)
        if task.save
          render json: task, adapter: :json, serializer: TaskSerializer
        else
          render json: { status: 400, task: task.errors }
        end
      end

      def unfinished_tasks
        today = Date.today
        tasks = current_user.tasks.left_joins(:study_record)
          .where('end_date < ? ', today.beginning_of_week)
          .where(study_record: {is_finished: false})
          .page(params[:page]).per(5)
        render json: tasks, adapter: :json, each_serializer: TaskSerializer
      end

      def create_from_templates
        task_templates = []
        if task_params[:copy_all] == "true"
          task_templates = current_user.task_templates
        else
          today = %w(日 月 火 水 木 金 土)[Date.today.wday]
          from = TaskTemplate::BASEWEEK[today].to_date
          to = TaskTemplate::BASEWEEK["日"].to_date
          task_templates = current_user.task_templates.where(start_date: from..to)
        end

        if task_templates.empty?
          render json: { message: "テンプレートを作成してください。" }, status: 400
        else
          tasks = Task.create_tasks_from_templates(templates: task_templates, after_num_weeks: 0)
          render json: tasks, adapter: :json, each_serializer: TaskSerializer  #バリデーションエラー時の処理を追加する
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
        params.permit(:study_material_id, :name, :start_date, :start_time, :end_time, :color, :copy_all, :page)
      end

      def correct_user
        @task = current_user.tasks.find(params[:id])
        redirect_to root_url if @task.nil?
      end

    end
  end
end