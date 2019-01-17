Rails.application.routes.draw do
  root "top#index"
  get "about" => "top#about", as: "about"
  # /about
  # about_path


  resources :members do
    get "search", on: :collection
  end

  resource :session, only: [:create, :destroy]
  resource :account, only: [:show, :edit, :update]
  resource :password, only: [:show, :edit, :update]

  resources :articles
end
