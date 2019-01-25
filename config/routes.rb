Rails.application.routes.draw do
  root "top#index"
  get "about" => "top#about", as: "about"
  # /about
  # about_path
  get "bad_request" => "top#bad_request"
  get "forbidden" => "top#forbidden"
  get "internal_server_error" => "top#internal_server_error"


  resources :members do
    get "search", on: :collection
    resources :entries, only: [:index]
  end

  resource :session, only: [:create, :destroy]
  resource :account, only: [:show, :edit, :update]
  resource :password, only: [:show, :edit, :update]

  resources :articles
  resources :entries do
    patch "like", "unlike", on: :member
    get "voted", on: :collection
    resources :images, controller: "entry_images" do
      patch :move_higher, :move_lower, on: :member
    end
  end

  namespace :admin do
    root "top#index"
    # admin_root_pathでURLパス生成
    # link_toの第二引数にシンボルで指定する場合は:admin_root
  end
end
