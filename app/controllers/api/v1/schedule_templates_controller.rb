module Api
  module V1
    class ScheduleTemplatesController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update, :destroy]

      def index
        @schedule_templates = current_user.schedule_templates.includes(:study_material)
        @study_materials = current_user.study_materials
        render json: { status: 'SUCCESS', 
                       message: 'Loaded posts', 
                       data: {
                           schedule_templates: @schedule_templates.as_json(
                            include: [:study_material],
                            methods: [:start, :end, :start_time_hm, :end_time_hm],
                            except: [:created_at, :updated_at, :start_time, :end_time]
                           ),
                           study_materials: @study_materials.as_json(
                            methods: [:image_url]
                           )
                        }
                      }
      end

      def create
        @schedule_template = current_user.schedule_templates.build(schedule_template_params)
        if @schedule_template.save
          render json: { status: 'SUCCESS', message: 'Loaded posts', data: @schedule_template }
        else
          render json: { status: 'SUCCESS', message: 'Loaded posts', data: @schedule_template.errors }
        end
      end

      def update
        if @schedule_template.update(schedule_template_params)
          render json: { status: 'SUCCESS', message: 'Loaded posts', data: @schedule_template }
        else
          render json: { status: 'SUCCESS', message: 'Loaded posts', data: @schedule_template.error }
        end
      end

      def destroy
        @schedule_template.destroy
        render json: { status: 'SUCCESS', message: 'Loaded posts', data: @schedule_template }
      end

      private

      def schedule_template_params
        params.permit(:study_material_id, :name, :start_time, :end_time, :day_of_week)
      end

      def correct_user
        @schedule_template = current_user.schedule_templates.find(params[:id])
        redirect_to root_url if @schedule_template.nil?
      end

    end
  end
end
