class BibleController < ApplicationController

  before_action :load_bible_book

  def select_book
    @books = BibleReader.book_names
  end

  def set_book
    session[:book] = params[:book]&.downcase
    if BibleReader.book_names.include?(session[:book])
      redirect_to bible_select_category_path
    else
      flash[:alert] = "Invalid book selected"
      redirect_to bible_select_book_path
    end
  end

  def select_category
  end

  def set_category
    session[:category] = params[:category]
    if session[:category] == "find_chapter"
      redirect_to bible_enter_chapter_path
    elsif session[:category] == "find_verse"
      redirect_to bible_enter_verse_path
    elsif session[:category] == 'find_range'
      redirect_to bible_enter_range_path
    elsif session[:category] == 'find_search'
      redirect_to bible_enter_search_path
    else
      flash[:alert] = "Unsupported action"
      redirect_to bible_select_category_path
    end
  end

  def enter_chapter
  end

  def show_chapter
    @chapter_number = params[:chapter]

    if @chapter_number.blank?
      @error = "Por favor ingrese un capítulo."
      return render :enter_chapter
    end

    begin
      @chapter = BibleReader.find_chapter(@book, @chapter_number)
    rescue => e
      Rails.logger.error("Chapter lookup failed: #{e.message}")
      @error = "Capítulo no encontrado o formato inválido."
    end

    render :enter_chapter
  end

  def enter_verse
  end

  def show_verse
    @reference = params[:reference]

    if @reference.blank?
      @error = "Por favor ingrese un versículo."
      return render :enter_verse
    end

    begin
      @verse = BibleReader.find_one_verse(@book, @reference)
    rescue => e
      Rails.logger.error("Verse lookup failed: #{e.message}")
      @error = "Versículo no encontrado o formato inválido."
    end

    render :enter_verse
  end

  def enter_range
  end

  def show_range
    @starting_verse = params[:starting_verse]
    @ending_verse = params[:ending_verse]

    if @starting_verse.blank? || @ending_verse.blank?
      @error = "Por favor ingrese un versiculo"
      return render :enter_range
    end

    begin
      @range = BibleReader.find_range(@book, @starting_verse, @ending_verse)
    rescue => e
      Rails.logger.error("Range lookup failed: #{e.message}")
      @error = "Selección no encontrada o formato inválido"
    end

    render :enter_range
  end

  def enter_search
  end

  def show_search
    @search_term = params[:search_term]

    if @search_term.blank?
      @error = 'Por favor ingrese búsqueda.'
      return render :enter_search
    end

    begin
      @search_results = BibleReader.find(@book, @search_term)
    rescue StandardError => e
      Rails.logger.error("Search lookup failed: #{e.message}")
      @error = 'Búsqueda no encontrada o formato inválido.'
    end

    render :enter_search
  end

  private

  def load_bible_book
    @book = session[:book] || 'exodo'
  end
end
