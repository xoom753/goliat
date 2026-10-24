Rails.application.routes.draw do
  resources :legacy_course_file_parsers
  resources :legacy_files_parsers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  resource :import_legacy_files, only: [:show, :create] do
    member do
      get :parse
      put :update_parser
      post :import_records
      post :ignore_file
      post :remove_file
      post :update_dates
    end
  end
  resources :origin_people, only: :index do
    collection do
      get :by_percentage
    end
  end
  resources :import_people, only: [:new, :create]
  resources :import_people_activities, only: [:new, :create]
  resources :people_activities, only: :index
  resources :courses, only: [:edit, :update, :destroy]
  resources :legacy_people, only: :index
  resources :import_errors, only: :index
  resources :legacy_activities, only: :index
  resources :legacy_activity_groups, only: [:index, :update]
  resources :legacy_person_activities, only: :index
  resources :extra_activities, only: [:index, :new, :edit, :update, :destroy] do
    member do
      put :update_name
      get :export
    end
  end
  resource :courses_by_month, only: [:show] do
    collection do
      get :export
    end
  end
  resources :person_pabellon_updates, only: [:index, :new, :create]
  resource :dashboard, only: [] do
    collection do
      get :people
    end
  end
  namespace :api do
    get :people
  end
end
