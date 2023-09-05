Rails.application.routes.draw do
  root "game#new"
  post "/game", to: "game#create"
  get "/game/:id", to: "game#show"
  get "/game", to: "game#show"
  post "/board", to: "board#create"
  get "/game/:id/results", to: "game#results", as: :results
  delete "/board/:id", to: "board#destroy", as: :destory_board
  delete "/game/:id", to: "game#destroy", as: :destory_game
  post "/board/:id/select", to: "board#select", as: :board_select
  post "/board/:id/move", to: "board#move", as: :board_move
  post "/board/:id/place", to: "board#place", as: :board_place

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
