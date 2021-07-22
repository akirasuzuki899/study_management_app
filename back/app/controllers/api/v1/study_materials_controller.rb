module Api
  module V1
    class StudyMaterialsController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:update, :destroy, :is_complete]

      def index
        study_materials = current_user.study_materials
        render json: study_materials, adapter: :json, each_serializer: StudyMaterialSerializer
      end

      def create
        study_material = current_user.study_materials.build(study_material_params)
        if study_material_params[:rakuten_image_url].present?
          study_material.attach_rakuten_image(study_material_params[:rakuten_image_url], study_material_params[:title])
        end

        study_material.save ? ( render json: study_material, adapter: :json, serializer: StudyMaterialSerializer )
                            : ( render json: { message: study_material.errors }, status: 400 )
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
        study_materials = []
        if params[:keyword].empty? 
          render json: { message: 'キーワードを入力してください' }, status:  400
          return 
        end

        results = RakutenWebService::Books::Book.search(title: params[:keyword], page: params[:page])
        results.each do |result|
          study_material = StudyMaterial.new(read(result))
          study_materials << study_material if new_material?(study_material)
        end

        if study_materials.present?
          render json: study_materials, adapter: :json, each_serializer: StudyMaterialSerializer
        else
          !!results ? ( render json: { study_materials: [], next: true }, status:  200 )
                    : ( render json: { study_materials: [], next: false, message: 'ヒットしませんでした' }, status:  200 )
        end

      end

      def is_complete
        @study_material.update(study_material_params) ? ( render json: @study_material, adapter: :json, serializer: StudyMaterialSerializer )
                                                      : ( render json: { message: @study_material.errors }, status: 400 )
      end

      private

      def study_material_params
        params.permit(:title, :image, :rakuten_image_url, :is_completed, :page)
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
