OBDComm::Application.routes.draw do
  get "analytics/create"
  match "analytics/create" => "analytics#create", :via => :post
  
  get "analytics/show"
  get "analytics/index"
  match "/analytics" => "analytics#index"

  get "static_pages/community_map"
  match "/map" => "static_pages#community_map"
  
  get "static_pages/help"
  match "/help" => "static_pages#help"
  
  get "static_pages/landing"
  
  get "static_pages/badges"
  match "/badges" => "static_pages#badges"
  
  get "static_pages/scoreboard"
  match "/scoreboard" => "static_pages#scoreboard"
  
  get "static_pages/auth"
  match "/auth" => "static_pages#auth"
  
  get "measurement/create"
  match '/measurement/create' => 'measurement#create', :via => :post
  
  get "measurement/show"
  match "/measurement/:id" => "measurement#show"

  get "trip/show_static_trip"
  
  get "trip/show_single_trip"
  get "trip/show"

  get "trip/show_abstract_trip"
  match "/trip/abstract" => "trip#abstract"
  
  get "trip/abstract"
  match "/trip/abstract/:id" => "trip#show_abstract_trip"
  
  match "/trip/show/:id" => "trip#show_single_trip"
  
  get "/trip/compare"

  get "trip/create"
  match '/trip/create' => 'trip#create', :via => :post

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

  root :to => 'static_pages#landing'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  mount CommunityEngine::Engine => "/"
end
