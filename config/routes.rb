Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :survivors, except: %i(destroy update) do
        put :last_location, on: :member
      end
    end
  end

end
