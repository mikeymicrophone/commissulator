Rails.application.routes.draw do
  resources :participants
  resources :assistants
  resources :deals
  root :to => 'home#landing'
  devise_for :agents
end
