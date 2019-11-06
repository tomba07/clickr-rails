Rails.application.routes.draw do
  resources :students
  resources :questions
  resources :school_classes
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'welcome#index'
end
