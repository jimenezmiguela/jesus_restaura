class BibleController < ApplicationController

  def enter_verse
    # Renders enter_verse.html.erb by default
  end

  def enter_chapter
    # Renders app/views/bible/enter_chapter.html.erb by default
  end

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
    # For now, we only support "find_verse"
  end

  def set_category
    session[:category] = params[:category]
    if session[:category] == "find_verse"
      redirect_to bible_enter_verse_path
    elsif session[:category] == "find_chapter"
      redirect_to bible_enter_chapter_path
    else
      flash[:alert] = "Unsupported action"
      redirect_to bible_select_category_path
    end
  end

  def enter_verse
    # Displays form to input verse reference
  end

  def show_verse
    @reference = params[:reference]
    @book = session[:book] || "exodo"

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

  def show_chapter
    @chapter_number = params[:chapter]
    @book = session[:book] || "exodo"

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
end
