class SavedVersesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_saved_verse, only: %i[show edit update destroy]

  def index
    @saved_verses = current_user.saved_verses
  end

  def show
    # @saved_verse set by before_action
  end

  def new
    @saved_verse = current_user.saved_verses.new
  end

  def create
    @saved_verse = current_user.saved_verses.new(saved_verse_params)
    if @saved_verse.save
      redirect_to saved_verses_path, notice: 'Versículo guardado.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @saved_verse.update(saved_verse_params)
      redirect_to saved_verses_path, notice: 'Versículo actualizado.'
    else
      render :edit
    end
  end

  def destroy
    @saved_verse.destroy
    redirect_to saved_verses_path, notice: 'Versículo eliminado.'
  end

  private

  def set_saved_verse
    @saved_verse = current_user.saved_verses.find(params[:id])
  end

  def saved_verse_params
    params.require(:saved_verse).permit(:book, :chapter, :verse, :note)
  end
end
