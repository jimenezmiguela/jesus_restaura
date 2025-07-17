Rails.application.routes.draw do
  root "bible#select_book"

  get  "/bible/book",      to: "bible#select_book",     as: :bible_select_book
  post "/bible/book",      to: "bible#set_book",        as: :bible_set_book

  get  "/bible/category",  to: "bible#select_category", as: :bible_select_category
  post "/bible/category",  to: "bible#set_category",    as: :bible_set_category

  get  "/bible/verse",     to: "bible#enter_verse",     as: :bible_enter_verse
  post "/bible/verse",     to: "bible#show_verse",      as: :bible_show_verse

  get  "/bible/chapter", to: "bible#enter_chapter", as: :bible_enter_chapter
  post "/bible/chapter", to: "bible#show_chapter",  as: :bible_show_chapter

  get '/bible/search', to: 'bible#enter_search', as: :bible_enter_search
  post '/bible/search', to: 'bible#show_search', as: :bible_show_search

  get '/bible/range', to: 'bible#enter_range', as: :bible_enter_range
  post '/bible/range', to: 'bible#show_range', as: :bible_show_range

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'chapter', to: 'bible#chapter'
      get 'verse', to: 'bible#verse'
      get 'range', to: 'bible#range'
      get 'search', to: 'bible#search'
    end
  end

end
