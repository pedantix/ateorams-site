Rails.application.routes.draw do


  devise_for :admins, controllers: { sessions: 'sessions'}
  

  resource :hire_us, only: [:show, :create] do
    get 'confirmation', on: :member
  end

  root "high_voltage/pages#show", id: 'home'
end
