class StudyMaterialsController < ApplicationController
  def index
    @study_materials = current_user.study_materials.page(params[:page]).per(2)
  end

  def new
    @study_material = StudyMaterial.new
  end

  def create
    @study_material = current_user.study_materials.build(study_material_params)
    @study_material.save
    redirect_to study_materials_path
  end

  def edit
    @study_material = StudyMaterial.find(params[:id])
  end

  def update
    @study_material = StudyMaterial.find(params[:id])
    @study_material.update(study_material_params)
    redirect_to study_materials_path
  end

  def destroy
    StudyMaterial.find(params[:id]).destroy
    redirect_to study_materials_path
  end


  private
    def study_material_params
      params.require(:study_material).permit(:name, :picture)
    end
end
