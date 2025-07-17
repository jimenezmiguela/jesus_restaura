module Api
  module V1
    class BibleController < ApplicationController
      before_action :set_book

      def verse
        reference = params[:reference]

        if reference.blank?
          return render json: { error: "Referencia faltante" }, status: :bad_request
        end

        begin
          verse_text = BibleReader.find_one_verse(@book, reference)
          render json: {
            book: @book,
            reference: reference,
            verse: verse_text
          }
        rescue => e
          Rails.logger.error("API verse lookup failed: #{e.message}")
          render json: { error: "Verso no se encontró, o formato inválido" }, status: :not_found
        end
      end

      def range
        start_ref = params[:starting_verse]
        end_ref = params[:ending_verse]

        if start_ref.blank? || end_ref.blank?
          return render json: { error: "Faltan parámetros de rango" }, status: :bad_request
        end

        begin
          verses = BibleReader.find_range(@book, start_ref, end_ref)
          render json: {
            book: @book,
            range: "#{start_ref} - #{end_ref}",
            verses: verses
          }
        rescue => e
          Rails.logger.error("API range lookup failed: #{e.message}")
          render json: { error: "Rango inválido o no encontrado" }, status: :not_found
        end
      end

      def chapter
        chapter_num = params[:chapter]

        if chapter_num.blank?
          return render json: { error: "Capítulo faltante" }, status: :bad_request
        end

        begin
          chapter = BibleReader.find_chapter(@book, chapter_num)
          render json: {
            book: @book,
            chapter: chapter_num,
            verses: chapter
          }
        rescue => e
          Rails.logger.error("API chapter lookup failed: #{e.message}")
          render json: { error: "Capítulo no encontrado o inválido" }, status: :not_found
        end
      end

      def search
        search_term = params[:search_term]

        if search_term.blank?
          return render json: { error: "Término de búsqueda faltante" }, status: :bad_request
        end

        begin
          results = BibleReader.find(@book, search_term)
          render json: {
            book: @book,
            search_term: search_term,
            results: results
          }
        rescue => e
          Rails.logger.error("API search failed: #{e.message}")
          render json: { error: "No se encontraron resultados" }, status: :not_found
        end
      end

      private

      def set_book
        @book = params[:book]&.downcase
        unless BibleReader.book_names.include?(@book)
          render json: { error: "Libro inválido o no especificado" }, status: :bad_request
        end
      end
    end
  end
end
