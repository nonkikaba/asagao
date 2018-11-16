Rails.application.routes.draw do
  root "top#index"
  get "about" => "top#about", as: "about"
  # /about
  # about_path
end
