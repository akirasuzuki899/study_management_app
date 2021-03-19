Rails.application.routes.draw do
  resources :study_notes
  resources :study_materials do
    collection do
      get :search
    end
    member do
      patch :is_complete
    end
  end

  devise_for :users
  root 'static_pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
