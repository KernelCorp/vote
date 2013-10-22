Vote::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => 'votings#index'
  ActiveAdmin.routes(self)

  resources :votings do
    get 'join/:id' => 'votings#join', :as => :join_to # Stupid resources do voting_join_to_path
    post ':id/info/:number/at/:position' => 'votings#info_about_number', :as => :number_info_at_position_for
    member do
      get 'widget'
    end
  end

  resources :participant, :controller => :participant

  devise_for :users,
    :skip => [ :sessions, :registrations, :passwords ]
  devise_for :participants, :organizations,
    :path_names => {
      :sign_in => 'login',
      :sign_up => 'regup',
      :sign_out => 'logout'
    },
    :controllers => { :sessions => :login }

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
