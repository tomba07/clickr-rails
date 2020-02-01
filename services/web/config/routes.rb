Rails.application.routes.draw do
  resources :buttons, only: %i[index]
  resources :student_device_mappings
  resources :question_responses
  resources :clicks
  resources :lessons do
    resource :evaluate, only: %i[show], controller: :lesson_evaluations do
      put :update_benchmark, path: :benchmark
    end
  end
  resources :questions do
    member { post :stop }
  end
  resources :students do
    member do
      post :decrement_score
      post :increment_score
    end
  end
  resources :school_classes do
    resource :seating_plan, only: %i[update show]
  end
  put 'users/school_class'
  devise_for :users

  root 'lesson_executions#show'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
