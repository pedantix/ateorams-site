Rails.application.routes.draw do


 resources :admin_users, only: [:index, :edit, :update]

  devise_for :admins, controllers: { sessions: 'sessions', passwords: 'passwords'}
  

  resource :hire_us, only: [:show, :create] do
    get 'confirmation', on: :member
  end

  root "high_voltage/pages#show", id: 'home'
end
