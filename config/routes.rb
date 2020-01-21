Rails.application.routes.draw do

  apipie
  namespace :api do
    namespace :v1 do
      resources :survivors, except: %i(destroy update) do
        put :last_location, on: :member
        post :trade, on: :collection
      end

      resources :reports, only: [] do
        collection do
          post :contamination
          get :lost_points
          get :infected_percentage
          get :not_infected_percentage
          get :average_amount_items
        end
      end
    end
  end

end
