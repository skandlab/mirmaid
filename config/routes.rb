ActionController::Routing::Routes.draw do |map|
  
  # cat ferret search before resources
  map.ferret_search ':controller/:action', :requirements => { :action => /ferret_search\S*/ }, :conditions => { :method => :get }
  
  map.resources :species, :only => [:index,:show] do |species|
    species.resources :precursors, :only => [:index]
    species.resources :matures, :only => [:index]
    species.resources :seed_families, :only => [:index]
    species.resources :papers, :only => [:index]
    MIRMAID_CONFIG.plugin_routes[:species].each do |pr|
      if pr[:rel][1] == :one
        species.resource pr[:core_method], :only => [:show]
      else
        species.resources pr[:core_method], :only => [:index]
      end
    end
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
    MIRMAID_CONFIG.plugin_routes[:precursor].each do |pr|
      if pr[:rel][1] == :one
        precursor.resource pr[:core_method], :only => [:show]
      else
        precursor.resources pr[:core_method], :only => [:index]
      end
    end
  end
  
  map.resources :matures, :only => [:index,:show] do |mature|
    mature.resource :species, :only => [:show]
    mature.resources :precursors, :only => [:index]
    mature.resources :papers, :only => [:index]
    mature.resources :seed_families, :only => [:index]
    MIRMAID_CONFIG.plugin_routes[:mature].each do |pr|
      if pr[:rel][1] == :one
        mature.resource pr[:core_method], :only => [:show]
      else
        mature.resources pr[:core_method], :only => [:index]
      end
    end
  end

  map.resources :precursor_families, :only => [:index,:show] do |pf|
    pf.resources :precursors, :only => [:index]
    MIRMAID_CONFIG.plugin_routes[:precursor_family].each do |pr|
      if pr[:rel][1] == :one
        pf.resource pr[:core_method], :only => [:show]
      else
        pf.resources pr[:core_method], :only => [:index]
      end
    end
  end

  map.resources :papers, :only => [:index,:show] do |paper|
    paper.resources :precursors, :only => [:index]
    paper.resources :matures, :only => [:index]
    paper.resources :species, :only => [:index]
    MIRMAID_CONFIG.plugin_routes[:paper].each do |pr|
      if pr[:rel][1] == :one
        paper.resource pr[:core_method], :only => [:show]
      els
        paper.resources pr[:core_method], :only => [:index]
      end
    end
  end

  map.resources :seed_families, :only => [:index,:show] do |sf|
    sf.resources :matures, :only => [:index]
    MIRMAID_CONFIG.plugin_routes[:seed_family].each do |pr|
      if pr[:rel][1] == :one
        sf.resource pr[:core_method], :only => [:show]
      else
        sf.resources pr[:core_method], :only => [:index]
      end
    end
  end

  map.resources :precursor_clusters, :only => [:index,:show] do |pc|
    pc.resources :precursors, :only => [:index]
    MIRMAID_CONFIG.plugin_routes[:precursor_cluster].each do |pr|
      if pr[:rel][1] == :one
        pc.resource pr[:core_method], :only => [:show]
      else
        pc.resources pr[:core_method], :only => [:index]
      end
    end
  end

  map.resources :genome_positions, :only => [:index,:show] do |gp|
    MIRMAID_CONFIG.plugin_routes[:genome_position].each do |pr|
      if pr[:rel][1] == :one
        gp.resource pr[:core_method], :only => [:show]
      else
        gp.resources pr[:core_method], :only => [:index]
      end
    end
  end

  map.resources :genome_contexts, :only => [:index,:show] do |gc|
    MIRMAID_CONFIG.plugin_routes[:genome_context].each do |pr|
      if pr[:rel][1] == :one
        gc.resource pr[:core_method], :only => [:show]
      else
        gc.resources pr[:core_method], :only => [:index]
      end
    end
  end

  map.resources :precursor_external_synonyms, :only => [:index,:show] do |pes|
    MIRMAID_CONFIG.plugin_routes[:precursor_external_synonym].each do |pr|
      if pr[:rel][1] == :one
        pes.resource pr[:core_method], :only => [:show]
      else
        pes.resources pr[:core_method], :only => [:index]
      end
    end
  end
  

  #
  # other routes
  #
  
  map.search 'search', :controller => 'search', :action => 'index'
  map.home 'home', :controller => 'home', :action => 'index'
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # pubmed search
  map.pubmed_search ':controller/:action', :requirements => { :controller => /search/, :action => /pubmed_papers/ }, :conditions => { :method => :get }
  
  # described routes
  map.resources :described_routes, :controller => "described_routes/rails", :only => [:index,:show]
    
end
