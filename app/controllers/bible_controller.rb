class BibleController < ApplicationController
  before_action :load_bible_book

  # -------------------------
  # Book Selection
  # -------------------------
  def select_book
    @books = BibleReader.book_names
  end

  def set_book
    session[:book] = params[:book]&.downcase
    if BibleReader.book_names.include?(session[:book])
      redirect_to bible_select_category_path
    else
      flash[:alert] = "Libro inválido seleccionado"
      redirect_to bible_select_book_path
    end
  end

  # -------------------------
  # Category Selection
  # -------------------------
  def select_category
  end

  def set_category
    session[:category] = params[:category]
    case session[:category]
    when "find_chapter" then redirect_to bible_enter_chapter_path
    when "find_verse"   then redirect_to bible_enter_verse_path
    when "find_range"   then redirect_to bible_enter_range_path
    when "find_search"  then redirect_to bible_enter_search_path
    else
      flash[:alert] = "Acción no soportada"
      redirect_to bible_select_category_path
    end
  end

  # -------------------------
  # Chapter
  # -------------------------
  def enter_chapter
    # renders form
  end

  def show_chapter
    @chapter_number = params[:chapter]
    if @chapter_number.blank?
      @error = "Por favor ingrese un capítulo."
    else
      begin
        @chapter = BibleReader.find_chapter(@book, @chapter_number)
      rescue => e
        Rails.logger.error("Chapter lookup failed: #{e.message}")
        @error = "Capítulo no encontrado o formato inválido."
      end
    end

    render :enter_chapter
  end

  # -------------------------
  # Verse
  # -------------------------
  def enter_verse
  end

  def show_verse
    @reference = params[:reference]
    if @reference.blank?
      @error = "Por favor ingrese un versículo."
    else
      begin
        @verse = BibleReader.find_one_verse(@book, @reference)
      rescue => e
        Rails.logger.error("Verse lookup failed: #{e.message}")
        @error = "Versículo no encontrado o formato inválido."
      end
    end

    render :enter_verse
  end

  # -------------------------
  # Range
  # -------------------------
  def enter_range
  end

  def show_range
    @starting_verse = params[:starting_verse]
    @ending_verse   = params[:ending_verse]

    if @starting_verse.blank? || @ending_verse.blank?
      @error = "Por favor ingrese un versículo de inicio y fin."
    else
      begin
        @range = BibleReader.find_range(@book, @starting_verse, @ending_verse)
      rescue => e
        Rails.logger.error("Range lookup failed: #{e.message}")
        @error = "Selección no encontrada o formato inválido."
      end
    end

    render :enter_range
  end

  # -------------------------
  # Search
  # -------------------------
  def enter_search
  end

  def show_search
    @search_term = params[:search_term]
    if @search_term.blank?
      @error = "Por favor ingrese un término de búsqueda."
    else
      begin
        @search_results = BibleReader.find(@book, @search_term)
      rescue => e
        Rails.logger.error("Search lookup failed: #{e.message}")
        @error = "Búsqueda no encontrada o formato inválido."
      end
    end

    render :enter_search
  end

  private

  def load_bible_book
    @book = session[:book] || "exodo"
  end
end
