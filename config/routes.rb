Rails.application.routes.draw do
  root "top#index"
  get "about" => "top#about", as: "about"
  # /about
  # about_path
  1.upto(18) do |n|
    get "lesson/step#{n}(/:name)" => "lesson#step#{n}"
  end

  resources :members do
    get "search", on: :collection
    resource :session, only: [:create, :destroy]
    resource :account, only: [:show, :edit, :update]
    resource :password, only: [:show, :edit, :update]
  end
end
