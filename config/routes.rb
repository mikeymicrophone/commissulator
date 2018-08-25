Rails.application.routes.draw do
  resources :landlords do
    collection do
      post :fabricate
    end
    resources :commissions
  end
  resources :commissions do
    collection do
      get :add_tenant_to
      post :fabricate
    end
    member do
      put :submit
      put :follow_up
    end
  end
  resources :assists
  resources :assistants
  resources :deals do
    collection do
      post :fabricate
    end
    member do
      get :pick_status_of
    end
  end
  root :to => 'home#landing'
  devise_for :agents
  resources :agents, :only => [:index, :edit, :update]
end
