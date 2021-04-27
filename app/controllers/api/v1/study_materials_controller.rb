module Api
  module V1
    class StudyMaterialsController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update, :destroy, :is_complete]

      def index
        @study_materials = current_user.study_materials.page(params[:page]).per(30)
        render json: { status: 'SUCCESS', message: 'Loaded posts', data: @study_materials }, methods: [:image_url]
      end

      def create
        @study_material = current_user.study_materials.build(study_material_params)
        @study_material.attach_rakuten_image(study_material_params[:rakuten_image_url], study_material_params[:title]) if study_material_params[:rakuten_image_url].present?
        if @study_material.save
          render json: { status: 'SUCCESS', message: 'Loaded posts', data: @study_material }
        else
          render json: { status: 'SUCCESS', message: 'Loaded posts', data: @study_material.errors }
        end
      end

      def update
        if @study_material.update(study_material_params)
          redirect_to study_materials_path
        else
          render 'edit'
        end
      end

      def destroy
        @study_material.destroy
        redirect_to study_materials_path
      end

      def search
        @study_materials = []
        if params[:keyword].present?
          results = RakutenWebService::Books::Book.search(title: params[:keyword], page: params[:page])
          results.each do |result|
            study_material = StudyMaterial.new(read(result))
            @study_materials << study_material if new_material?(study_material)
          end
        end
        render json: @study_materials, status: :ok, methods: [:rakuten_image_url]
      end

      def is_complete
        if @study_material.update(study_material_params)
          render json: { status: 'SUCCESS', message: 'Loaded posts', data: @study_material }
        else
          render json: { status: 'ERROR', message: 'Loaded posts', data: @study_material.errors }
        end
      end

      private

      def study_material_params
        params.permit(:title, :image, :rakuten_image_url, :is_completed)
      end

      def correct_user
        @study_material = current_user.study_materials.find(params[:id])
        redirect_to root_url if @study_material.nil?
      end

      def read(result)
        title = result['title']
        rakuten_image_url = result['mediumImageUrl']
        {
          title: title,
          rakuten_image_url: rakuten_image_url
        }
      end

      def new_material?(new_material)
        study_materials = current_user.study_materials.select(:title)
        study_materials.each do |study_material|
          return false if study_material[:title] == new_material[:title]
        end
        true
      end
    end
  end
end
