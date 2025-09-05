class SavedSectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_saved_section, only: %i[show edit update destroy]

  # GET /saved_sections
  def index
    @saved_sections = current_user.saved_sections.order(created_at: :desc)
  end

  # GET /saved_sections/:id
  def show
    # Shows a single saved section
  end

  # GET /saved_sections/new
  def new
    @saved_section = current_user.saved_sections.new
  end

  # POST /saved_sections
  def create
    @saved_section = current_user.saved_sections.new(saved_section_params)
    if @saved_section.save
      redirect_to saved_sections_path, notice: 'Sección guardada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /saved_sections/:id/edit
  def edit; end

  # PATCH/PUT /saved_sections/:id
  def update
    if @saved_section.update(saved_section_params)
      redirect_to saved_sections_path, notice: 'Sección actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /saved_sections/:id
  def destroy
    @saved_section.destroy
    redirect_to saved_sections_path, notice: 'Sección eliminada.'
  end

  private

  def set_saved_section
    @saved_section = current_user.saved_sections.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to saved_sections_path, alert: 'No se encontró esta sección.'
  end

  def saved_section_params
    params.require(:saved_section).permit(:title, :description, :content, :note)
  end
end
