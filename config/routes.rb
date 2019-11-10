Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'lesson_executions/index'
  resources :lessons
  put 'users/school_class'
  devise_for :users
  resources :students
  resources :questions
  resources :school_classes

  root 'lesson_executions#index'
end
