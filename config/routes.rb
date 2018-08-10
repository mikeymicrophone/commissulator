Rails.application.routes.draw do
  resources :assistants
  resources :deals
  root :to => 'home#landing'
  devise_for :agents
end
