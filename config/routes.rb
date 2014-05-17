# -*- encoding : utf-8 -*-
D2game::Application.routes.draw do

  resources :games do

    resources :units, only: [ :index, :show, :create, :destroy ]

    member do
      post 'make_action'
    end

    #collection do
    #  get 'sold'
    #end
  end

  #resources :units

  resources :prototypes

  resources :level_ups

  resources :maps,            only: [ :index, :show ]
  resources :effects,         only: [ :index, :show ]
  resources :password_resets, only: [ :new, :create, :edit, :update ]
  resources :sessions,        only: [ :new, :create ]
  resources :users

  match 'login'  => 'sessions#new',     :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'registration' => 'users#new',  :as => :registration
  match 'forgotten_password'        => 'password_resets#new',   :as => :forgotten_password
  match 'users/:id/edit_password'   => 'users#edit_password',   :as => :edit_password
  match 'users/:id/update_password' => 'users#update_password', :as => :update_password
  match 'users?mode=all'            => 'users#index',           :as => :all_users

  match 'users?mode=all'            => 'users#index',           :as => :all_users



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
    root :to => 'maps#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
