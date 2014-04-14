BPSF::Application.routes.draw do
  root to: 'pages#home'
  get '/search', to: 'pages#search', as: :search

  resources :grants, except: :index do
    post 'rate', on: :member
  end
  scope '/grants' do
    get ':id/edit_general_info/',    to: 'grants#edit_general_info',    as: :edit_general
    get ':id/edit_logistics/',       to: 'grants#edit_logistics',       as: :edit_logistics
    get ':id/edit_budget/',          to: 'grants#edit_budget',          as: :edit_budget
    get ':id/edit_methods/',         to: 'grants#edit_methods',         as: :edit_methods
    post ':id/crowdfund',            to: 'grants#crowdfund_form',       as: :crowdfund_form
    post ':id/preapprove',           to: 'grants#preapprove',           as: :preapprove_grant
    get  ':id/previous_show',        to: 'grants#previous_show',        as: :previous_show
    post ':id/to_draft',             to: 'grants#to_draft',             as: :to_draft
    post ':id/:state',               to: 'admin/dashboard#grant_event', as: :grant_event
  end

  resources :drafts, controller: 'draft_grants', except: [:show, :index]

  resources :preapproved_grants, only: [:show, :destroy]
  scope '/preapproved_grants' do
    post ':id/convert', to: 'preapproved_grants#convert', as: :preapproved_convert
  end

  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :user, except: [:index, :new, :create, :destroy]

  scope '/user' do
    put ':id/update_password', to: 'user#update_password', as: :update_password
  end

  scope '/users' do
    post ':id/approve', to: 'user#approve', as: :approve_user
    post ':id/reject', to: 'user#reject', as: :reject_user
    get ':id/update_credit_card', to: 'user#credit_card', as: :update_credit_card_info
  end

  resources :payments, only: [:create, :destroy]
  get 'payments/success/:grant_id/:payment_id/', to: 'payments#success', as: :payment_success

  namespace :recipient do
    get '', to: 'dashboard#index', as: :dashboard
  end

  namespace :admin do
    get '', to: 'dashboard#index', as: :dashboard
    post '', to: 'dashboard#index', as: :filter_school
    post '', to: 'dashboard#index', as: :filter_donated
  end

  post 'crowdfund/create'
  post 'crowdfund/update'
  resources :recipient_profile, only: :update
  resources :admin_profile,     only: :update
end
