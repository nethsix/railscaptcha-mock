Rails.application.routes.draw do
  # mount Upmin::Engine => '/admin'
  root to: 'visitors#index'
  get '/dashboard', to: 'dashboard#index'
  get '/apps', to: 'app#index'
  get '/apps/create', to: 'app#create'
  post '/apps/create', to: 'app#sub'
  get '/apps/edit/:id', to: 'app#edit'
  get '/apps/transactions/:id', to: 'app#transactions'
  post '/apps/edit/:id', to: 'app#edit'
  get '/apps/custom/:id', to: 'app#custom'
  post '/apps/custom/:id', to: 'app#custom_post'
  get '/apps/delete/:id', to: 'app#delete'
  get '/apps/instructions/:id', to: 'app#instructions'
  get '/docs', to: 'docs#index'
  get '/docs/web', to: 'docs#web'
  get '/docs/api', to: 'docs#api'
  get '/docs/android', to: 'docs#android'
  get '/docs/ios', to: 'docs#ios'
  get '/account', to: 'account#index'
  post '/account/update', to: 'account#update'
  get '/account/change-email', to: 'account#email'
  get '/account/change-password', to: 'account#password'
  get '/account/change-credit-card', to: 'account#payment'
  post '/account/update_email', to: 'account#update_email'
  post '/account/update_password', to: 'account#update_password'
  get '/metrics', to: 'metrics#index'

  get '/test', to: 'app#test'

  devise_for :users
  resources :users

  # API
  namespace :api do
    get 'metrics' => 'metrics#index'
  end

  # ADMIN
  get "admin" => 'admin/home#index'
  namespace :admin do
    # get 'users/unassume/:id' => 'users#unassume', :as => 'unassume_user'
    # Restrict access to admin only
    authenticate :user, lambda { |u| u.admin? } do
      get 'home' => 'home#index'
      # resources :users
      # get 'users/assume/:id' => 'users#assume', :as => 'assume_user'
    end
  end

end
