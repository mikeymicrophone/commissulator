Rails.application.routes.draw do
  root :to => 'home#landing'
  devise_for :agents
end
