ActionController::Routing::Routes.draw do |map|
  readonly = [:create, :new, :update, :destroy, :edit]
  
  map.resources :species, :has_many => [:precursors,:matures,:papers], :except => readonly
  
  map.resources :precursors, :has_one => [:precursor_family,:species], :has_many => [:matures,:papers,:genome_positions,:genome_contexts,:precursor_external_synonyms,:precursor_clusters], :except => readonly
  
  map.resources :matures, :has_one => [:species], :has_many => [:precursors,:papers,:seed_families], :except => readonly
  
  map.resources :precursor_families, :has_many => :precursors, :except => readonly
    
  map.resources :papers, :has_many => [:precursors, :species, :matures], :except => readonly
  
  map.resources :seed_families, :has_many => [:matures], :except => readonly
  
  map.resources :precursor_clusters, :has_many => [:precursors], :except => readonly
  
  map.resources :genome_positions, :except => readonly

  map.resources :genome_contexts, :except => readonly

  map.resources :precursor_external_synonyms, :except => readonly


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  map.search 'search', :controller => 'search', :action => 'index'
  map.home 'home', :controller => 'home', :action => 'index'
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
