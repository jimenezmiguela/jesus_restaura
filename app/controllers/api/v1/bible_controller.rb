# app/controllers/api/v1/bible_controller.rb
module Api
  module V1
    class BibleController < ApplicationController
      def verse
        book = params[:book]&.downcase
        reference = params[:reference]

        if book.blank? || reference.blank?
          return render json: { error: "Libro no se encuentra" }, status: :bad_request
        end

        begin
          verse_text = BibleReader.find_one_verse(book, reference)
          render json: {
            book: book,
            reference: reference,
            verse: verse_text
          }
        rescue => e
          Rails.logger.error("API verse lookup failed: #{e.message}")
          render json: { error: "Verso no se encontró, o formato invalido" }, status: :not_found
        end
      end
    end
  end
end
