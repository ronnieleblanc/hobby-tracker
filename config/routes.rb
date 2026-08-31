Rails.application.routes.draw do
  root "collections#index"
  resources :collections, only: %i[index show] do
    resources :owned_sets, only: %i[show new create destroy] do
      post :update_status, on: :member
    end
    post "miniatures/update_status_group", to: "miniatures#update_status_group",
         as: :update_miniatures_status
    delete "miniatures/delete_group", to: "miniatures#destroy_group",
           as: :delete_miniatures_group
    resources :miniatures, only: %i[show edit update new create destroy]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
