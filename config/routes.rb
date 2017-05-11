Rails.application.routes.draw do
  get 'zulu_c/index'

  get "/api_test", to: "zulu_c#api_test"

  post "/ean", to: "zulu_c#ean"
    
  root "zulu_c#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
