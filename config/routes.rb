Rails.application.routes.draw do

  resources :tags, only: :show

  resources :blogs
  resources :work_inquiries, only: [:index, :edit, :update, :show]

  resources :admin_users, only: [:index, :edit, :update]

  devise_for :admins, controllers: { sessions: 'sessions', passwords: 'passwords' } #, registrations: 'registrations'}
  

  resource :hire_us, only: [:show, :create] do
    get 'confirmation', on: :member
  end

  root "high_voltage/pages#show", id: 'home'
end
