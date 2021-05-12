module Api
  module V1
    class TaskTemplatesController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update, :destroy]

      def index
        @task_templates = current_user.task_templates
        render json: { status: 'SUCCESS', 
                       message: 'Loaded posts', 
                       task_templates: @task_templates.as_json(
                         methods: [:start, :end, :start_time_hm, :end_time_hm],
                         except: [:created_at, :updated_at, :start_time, :end_time],
                       )
                      }
      end

      def create
        @task_template = current_user.task_templates.build(task_template_params)
        if @task_template.save
          render json: { status: 'SUCCESS', 
                         message: 'Loaded posts', 
                         task_template: @task_template.as_json(
                          methods: [:start, :end, :start_time_hm, :end_time_hm],
                          except: [:created_at, :updated_at, :start_time, :end_time],
                         )
                        }
        else
          render json: { status: 'SUCCESS', message: 'Loaded posts', task_template: @task_template.errors }
        end
      end

      def update
        if @task_template.update(task_template_params)
          render json: { status: 'SUCCESS', 
                          message: 'Loaded posts', 
                          task_template: @task_template.as_json(
                            methods: [:start, :end, :start_time_hm, :end_time_hm],
                            except: [:created_at, :updated_at, :start_time, :end_time],
                           ) 
                        }
        else
          render json: { status: 'SUCCESS', message: 'Loaded posts', task_template: @task_template.error }
        end
      end

      def destroy
        @task_template.destroy
        render json: { status: 'SUCCESS', message: 'Loaded posts', task_template: @task_template }
      end

      private

      def task_template_params
        params.permit(:study_material_id, :name, :start_time, :end_time, :day_of_week)
      end

      def correct_user
        @task_template = current_user.task_templates.find(params[:id])
        redirect_to root_url if @task_template.nil?
      end

    end
  end
end
