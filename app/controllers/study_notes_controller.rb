class StudyNotesController < ApplicationController
  def index
    @study_notes = current_user.study_notes.page(params[:page]).per(2)
  end
  
  def new
    @study_note = StudyNote.new
  end

  def create
    @study_note = current_user.study_notes.build(study_note_params)
    if @study_note.save
      redirect_to study_notes_path
    else
      render 'new'
    end
  end

  def show
  end

  def edit
    @study_note = StudyNote.find(params[:id])
  end

  def update
    @study_note = StudyMaterial.find(params[:id])
    if @study_note.update(study_note_params)
      redirect_to study_notes_path
    else
      render 'edit'
    end
  end

  def destroy
    StudyNote.find(params[:id]).destroy
    redirect_to study_notes_path
  end



  private
    def study_note_params
      params.require(:study_note).permit(:page_number, :content, :study_material_id, :title)
    end
end
