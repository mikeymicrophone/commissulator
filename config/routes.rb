Rails.application.routes.draw do
  resources :tenants
  resources :involvements
  resources :roles
  resources :packages
  resources :documents
  resources :landlords do
    collection do
      post :fabricate
    end
  end
  resources :commissions do
    collection do
      get :add_tenant_to
      post :fabricate
      get :prune
    end
    member do
      put :submit
      put :follow_up
    end
  end
  resources :assists
  resources :agents
  resources :deals do
    collection do
      post :fabricate
      get :prune
    end
    member do
      get :pick_status_of
    end
  end
  root :to => 'home#landing'
  devise_for :avatars, :controllers => { :omniauth_callbacks => 'avatars/omniauth_callbacks' }
  resources :avatars, :only => [:index, :show, :edit, :update]
  resources :apartments
  resources :social_accounts
  resources :emails
  resources :phones
  resources :niches
  resources :industries
  resources :employments
  resources :employers
  resources :leases
  resources :registrants
  resources :clients
  resources :referral_sources
  resources :registrations do
    member do
      get :display
    end
    collection do
      post :fabricate
    end
  end
  get '/register' => 'home#registration', :as => 'begin_registration'
  post '/register' => 'home#submit', :as => 'submit_registration'
  get '/toggle_navigation' => 'home#toggle_navigation', :as => 'toggle_navigation'
  get '/thanks' => 'home#thanks', :as => 'thanks'
end
