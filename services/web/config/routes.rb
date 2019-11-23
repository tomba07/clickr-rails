Rails.application.routes.draw do
  resources :buttons, only: [:index]
  resources :student_device_mappings
  resources :question_responses
  resources :clicks
  resources :lesson_executions, only: [:index]
  resources :lessons
  resources :questions
  resources :students
  resources :school_classes do
    put 'seating_plan', on: :member
  end
  put 'users/school_class'
  devise_for :users

  root 'lesson_executions#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
