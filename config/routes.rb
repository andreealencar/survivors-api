Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :survivors, except: %i(destroy update) do
        put :last_location, on: :member
        post :trade, on: :collection
      end

      resources :contamination_reports, only: :create
    end
  end

end
