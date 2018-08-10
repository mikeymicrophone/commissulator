Rails.application.routes.draw do
  resources :deals
  root :to => 'home#landing'
  devise_for :agents
end
