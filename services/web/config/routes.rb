Rails.application.routes.draw do
  resources :buttons, only: [:index]
  resources :student_device_mappings
  resources :question_responses
  resources :clicks
  resource :lesson_execution, only: [:show]
  resources :lessons
  resources :questions
  resources :students do
    member do
      post :decrement_score
      post :increment_score
    end
  end
  resources :school_classes do
    resource :seating_plan, only: [:update, :show]
  end
  put 'users/school_class'
  devise_for :users

  root 'lesson_executions#show'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
