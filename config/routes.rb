Rails.application.routes.draw do
  namespace :api do
    resources :broadcastings, only: :index
  end

  mount Ckeditor::Engine => '/ckeditor'
  get 'welcome/index'

  get '/about', to: 'welcome#about'

  root 'welcome#index'

  namespace :web_api do
    resources :buildings, only: [:index, :show]

    resources :localities, only: [:index]

    resources :districts, only: [:index]

    resources :regions, only: [:index]
    resources :reports, only: [:index]
  end

  scope module: :web do
    namespace :admin do
      root 'welcome#index'

      resource :session, only: [:new, :create, :destroy]

      resources :buildings, only: [:index, :new, :create, :edit, :update, :destroy] do
        member do
          get :monitoring
        end
      end

      resources :users, only: [:index, :new, :create, :edit, :update, :destroy]

      resources :feedback, only: [:index, :show]

      resources :reports, only: [:index, :create, :show, :destroy]

      resources :audit, only: [:index]
    end

    resource :feedback, only: [:new, :create, :show]

    resources :buildings, only: [:show]
  end
end
