Rails.application.routes.draw do
  root 'home#index'
  resources :inoculations
  resources :vaccines
  resources :countries
  # Application Programming Interface aka Application Service Knocker
  namespace :ask do
    # version, handled through code names, here `for`
    namespace :for do
      resources :inoculations
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
