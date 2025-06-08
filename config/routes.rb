Rails.application.routes.draw do
  root "bible#select_book"

  get  "/bible/book",      to: "bible#select_book",     as: :bible_select_book
  post "/bible/book",      to: "bible#set_book",        as: :bible_set_book

  get  "/bible/category",  to: "bible#select_category", as: :bible_select_category
  post "/bible/category",  to: "bible#set_category",    as: :bible_set_category

  get  "/bible/verse",     to: "bible#enter_verse",     as: :bible_enter_verse
  post "/bible/verse",     to: "bible#show_verse",      as: :bible_show_verse
end
