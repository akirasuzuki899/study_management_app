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
      resources :study_records
      resources :mandala_charts
      
      get 'study_materials/study_notes', to: 'study_materials/study_notes#index'
      get 'mandala_items/study_notes', to: 'mandala_items/study_notes#index'
      post 'study_notes/download', to: 'study_notes#download'
      resources :mandala_items, shallow: true  do
        resources :study_notes, module: :mandala_items, except: :index 
      end
      resources :study_materials, shallow: true  do
        resources :study_notes, module: :study_materials, except: :index 
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
