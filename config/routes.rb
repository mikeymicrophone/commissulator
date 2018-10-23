Rails.application.routes.draw do
  resources :calendar_events do
    collection do
      get :token
      get :microsoft_token
    end
  end
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
  devise_for :avatars#, :controllers => { :omniauth_callbacks => 'avatars/omniauth_callbacks' }
  resources :avatars, :only => [:index, :show, :edit, :update] do
    member do
      put :activate
      put :deactivate
    end
  end
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
      get :card
    end
    collection do
      post :fabricate
    end
  end
  get '/register' => 'home#registration', :as => 'begin_registration'
  get '/registrant_add' => 'home#registrant_add', :as => 'registrant_add'
  post '/register' => 'home#submit', :as => 'submit_registration'
  get '/toggle_navigation' => 'home#toggle_navigation', :as => 'toggle_navigation'
  get '/thanks' => 'home#thanks', :as => 'thanks'
end
