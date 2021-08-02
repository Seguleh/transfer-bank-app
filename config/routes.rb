Rails.application.routes.draw do

  devise_for :users, :skip => [:registrations]
    as :user do
    root to: 'devise/sessions#new'
    get '/sign_in' => 'devise/sessions#new'
    get '/sign_up' => 'devise/registrations#new',     as: 'new_user_registration'
    get 'users/edit' => 'devise/registrations#edit',  as: 'edit_user_registration'
    put 'users' => 'devise/registrations#update',     as: 'user_registration'
    get 'users',  to: 'dashboard#index'
    end
  
  get   'dashboard',  to: 'dashboard#index'
  post  'dashboard',  to: 'dashboard#send_transfer',  as: 'dashboard_send_transfer'

end
