Rails.application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      # models auth
      resources :users, except: [:edit, :new], shallow: true do
        member do
          put :password
          put :register_device
        end
        collection do
          patch 'status' => 'users#update_status'
          namespace :auth do
            put 'omniauth/:provider' => 'omniauth#all'
            patch 'omniauth/:provider' => 'omniauth#all'
            post 'sign_in' => 'sessions#create'
            delete 'sign_out' => 'sessions#destroy'
          end
          post :reset_password
        end
      end
      resources :enterprises, except: [:edit, :new]
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
