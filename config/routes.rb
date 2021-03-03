Rails.application.routes.draw do
  # get 'study_notes/index'
  # get 'study_notes/show'
  # get 'study_notes/edit'
  # get 'study_notes/new'
  # get 'study_materials/index'
  # get 'study_materials/new'
  # post 'study_materials/create'
  resources :study_notes
  resources :study_materials
  devise_for :users
  root 'static_pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
