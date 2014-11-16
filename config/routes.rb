Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # all visitor
  root 'welcomes#index'
  get '/users/list' => 'welcomes#list', as: :list_welcome

  # admin
  get '/admins' => 'admins#index', as: :index_admins
  get '/admins/register' => 'admins#new_sheet', as: :new_sheet_admins
  post '/admins/register' => 'admins#create_sheet', as: :create_sheet_admins
  get '/admins/notice' => 'admins#new_notice', as: :new_notice_admins
  post '/admins/notice' => 'admins#create_notice', as: :create_notice_admins
  mount RailsAdmin::Engine => '/admins/model', as: :rails_admin

  # rival
  get '/rival/list' => 'rivals#list', as: :list_rival
  get '/rival/reverse_list' => 'rivals#reverse_list', as: :reverse_list_rival
  get '/rival/clear/:id' => 'rivals#clear', as: :clear_rival
  get '/rival/hard/:id' => 'rivals#hard', as: :hard_rival
  post '/rival/remove/:id' => 'rivals#remove', as: :remove_rival
  post '/rival/register/:id' => 'rivals#register', as: :register_rival

  # sheet
  get '/sheets/:iidxid/clear' => 'sheets#clear', as: :clear_sheets
  get '/sheets/:iidxid/hard' => 'sheets#hard', as: :hard_sheets

  # score
  get '/scores/:id.:format' => 'scores#attribute', as: :scores
  post '/scores/:id' => 'scores#update', as: :score
  patch '/scores/:id' => 'scores#update'

  # log
  get '/logs/:iidxid/list' => 'logs#list', as: :list_logs
  get '/logs/:iidxid/sheet' => 'logs#sheet', as: :sheet_log
  get '/logs/:iidxid/:date' => 'logs#show', as: :show_log
end
