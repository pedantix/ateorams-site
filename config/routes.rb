Rails.application.routes.draw do


  resource :hire_us, only: [:show, :create] do
    get 'confirmation', on: :member

  end

  root "high_voltage/pages#show", id: 'home'
end
