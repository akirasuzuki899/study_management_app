Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1, format: 'json' do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :tasks do
        collection do
          post :create_from_templates
          get :unfinished_tasks
        end
      end
      resources :task_templates
      resources :mandala_charts
      resources :mandala_items
      resources :study_records
      resources :study_notes do
        collection do
          post :download
          # get :url_metadata
        end
      end
      resources :study_materials do
        collection do
          get :search
        end
        member do
          patch :is_complete
        end
      end
      resources :charts do
        collection do
          get :daily
          get :weekly
          get :monthly
        end
      end
      get 'health_check', to: 'health_check#index'
      root 'static_pages#home'
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
