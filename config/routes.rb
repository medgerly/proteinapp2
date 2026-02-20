Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  authenticated :user do
    root "dashboard#index", as: :authenticated_root
  end

  root "users/sessions#new"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :goals do
    resources :meals do
      collection do
        post :estimate
      end
    end
  end

  resources :meal_templates, only: [:index, :destroy]
end
