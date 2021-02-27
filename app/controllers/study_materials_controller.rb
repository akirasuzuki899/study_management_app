class StudyMaterialsController < ApplicationController
  def index
    @study_material = current_user.study_materials.first
    # byebug
  end

  def new
    @study_material = StudyMaterial.new
  end

  def create
    @study_material = current_user.study_materials.build(study_material_params)
    @study_material.save
    redirect_to study_materials_path
  end

  private
    def study_material_params
      params.require(:study_material).permit(:name, :picture)
    end
  
end
