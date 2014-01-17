BPSF::Application.routes.draw do
  root to: 'pages#home'
  get '/search', to: 'pages#search', as: :search
  get '/successful', to: 'pages#successful', as: :successful

  resources :grants, except: :index do
    post 'rate', on: :member
  end
  scope '/grants' do
    get ':id/edit_general_info/', to: 'grants#edit_general_info',    as: :edit_general
    get ':id/edit_logistics/',    to: 'grants#edit_logistics',       as: :edit_logistics
    get ':id/edit_budget/',       to: 'grants#edit_budget',          as: :edit_budget
    get ':id/edit_methods/',      to: 'grants#edit_methods',         as: :edit_methods
    post ':id/crowdfund',         to: 'grants#crowdfund_form',       as: :crowdfund_form
    post ':id/preapprove',        to: 'grants#preapprove',           as: :preapprove_grant
    post ':id/:state',            to: 'admin/dashboard#grant_event', as: :grant_event
  end

  resources :drafts, controller: 'draft_grants', except: [:show, :index]
  scope '/drafts' do
    get ':id/edit_general_info/', to: 'draft_grants#edit_general_info', as: :draft_edit_general
    get ':id/edit_logistics/',    to: 'draft_grants#edit_logistics',    as: :draft_edit_logistics
    get ':id/edit_budget/',       to: 'draft_grants#edit_budget',       as: :draft_edit_budget
    get ':id/edit_methods/',      to: 'draft_grants#edit_methods',      as: :draft_edit_methods
  end

  resources :preapproved_grants, only: [:show, :destroy]
  scope '/preapproved_grants' do
    post ':id/convert', to: 'preapproved_grants#convert', as: :preapproved_convert
  end

  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :user, except: [:index, :new, :create, :destroy]

  scope '/users' do
    post ':id/approve', to: 'user#approve', as: :approve_user
    post ':id/reject', to: 'user#reject', as: :reject_user
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
  resources :recipient_profile, only: :update
  resources :admin_profile,     only: :update
end
