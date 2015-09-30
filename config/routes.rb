Rails.application.routes.draw do

  root 'home#index'

  resources :passwords, only: [:new, :create, :update] do
    get 'edit', on: :collection
  end

  resources :sessions, only: [:create, :destroy]

  concern :pagination do
    get 'page/:page' => :index, as: :page, on: :collection
  end

  resources :users, except: [:new, :destroy], concerns: :pagination do
    collection do
      get 'account_activation'
      post 'update_state'
    end
    member do
      get 'contribution'
      post 'update_image'
      get 'projects' => 'projects#index'
    end
  end

  resources :projects, concerns: :pagination do
    collection do
      get ':catagory' => :view_all, as: :catagory, 
          constraints: -> (request) { PROJECT_CATAGORIES.include?(request.path_parameters[:catagory]) }
    end
    member do
      post 'update_status'
      scope 'transactions', controller: :transactions do
        post 'new', as: 'new_transaction_for'
        get 'build', as: 'build_transaction_for'
        post 'create', as: 'create_transaction_for'
        get 'success', as: 'success_transaction_for'
      end
    end
  end

  resources :transactions, only: [:index] do
    get 'download_receipt/:stripeToken' => :download_receipt, as: :download_receipt, on: :collection
  end

  resources :comments, only: [:create, :destroy]

  namespace :apis do
    get 'projects' => 'projects#index', defaults: { format: 'JSON' }
  end
end