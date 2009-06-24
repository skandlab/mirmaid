ActionController::Routing::Routes.draw do |map|
  
  map.ferret_search ':controller/:action', :requirements => { :action => /ferret_search\S*/ }, :conditions => { :method => :get }
  
  map.resources :species, :only => [:index,:show] do |species|
    species.resources :precursors, :only => [:index]
    species.resources :matures, :only => [:index]
    species.resources :papers, :only => [:index]
  end
  
  map.resources :precursors, :only => [:index,:show] do |precursor|
    precursor.resource :species, :only => [:show]
    precursor.resource :precursor_family, :only => [:show]
    precursor.resources :matures, :only => [:index]
    precursor.resources :papers, :only => [:index]
    precursor.resources :genome_positions, :only => [:index]
    precursor.resources :genome_contexts, :only => [:index]
    precursor.resources :precursor_external_synonyms, :only => [:index]
    precursor.resources :precursor_clusters, :only => [:index]
  end
  
  map.resources :matures, :only => [:index,:show] do |mature|
    mature.resource :species, :only => [:show]
    mature.resources :precursors, :only => [:index]
    mature.resources :papers, :only => [:index]
    mature.resources :seed_families, :only => [:index]
  end

  map.resources :precursor_families, :only => [:index,:show] do |pf|
    pf.resources :precursors, :only => [:index]
  end

  map.resources :papers, :only => [:index,:show] do |paper|
    paper.resources :precursors, :only => [:index]
    paper.resources :matures, :only => [:index]
    paper.resources :species, :only => [:index]
  end

  map.resources :seed_families, :only => [:index,:show] do |sf|
    sf.resources :matures, :only => [:index]
  end

  map.resources :precursor_clusters, :only => [:index,:show] do |pc|
    pc.resources :precursors, :only => [:index]
  end

  map.resources :genome_positions, :only => [:index,:show]

  map.resources :genome_contexts, :only => [:index,:show]

  map.resources :precursor_external_synonyms, :only => [:index,:show]

  map.search 'search', :controller => 'search', :action => 'index'
  map.home 'home', :controller => 'home', :action => 'index'
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # pubmed search
  map.pubmed_search ':controller/:action', :requirements => { :controller => /search/, :action => /pubmed_papers/ }, :conditions => { :method => :get }
  
  # described routes
  map.resources :described_routes, :controller => "described_routes/rails", :only => [:index,:show]
    
end
