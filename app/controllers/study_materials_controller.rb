class StudyMaterialsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy, :is_complete]

  def index
    @study_materials = current_user.study_materials.page(params[:page]).per(5)
    # debugger
  end

  def new
    @study_material = StudyMaterial.new
  end

  def create
    @study_material = current_user.study_materials.build(study_material_params)
    if @study_material.save
      redirect_to study_materials_path
    else
      render 'new'
    end
  end

  def edit; end

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
      results = RakutenWebService::Books::Book.search(title: params[:keyword])
      results.each do |result|
        study_material = StudyMaterial.new(read(result))
        @study_materials << study_material
      end
    end
  end

  def is_complete
    @study_material.update(complete_params)
    redirect_to search_study_materials_path
  end

  private

    def study_material_params
      params.require(:study_material).permit(:name, :picture)
    end

    def complete_params
      params.permit(:is_completed)
    end

    def correct_user
      @study_material = current_user.study_materials.find_by(id: params[:id])
      redirect_to root_url if @study_material.nil?
    end
    

    def read(result)
      title = result['title']
      # url = result['itemUrl']
      # isbn = result['isbn']
      image_url = result['mediumImageUrl']
      {
        name: title,
        # url: url,
        # isbn: isbn,
        material_url: image_url,
      }
      # debugger

    end
end
