# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '150a59e42e74cf3e40d571817d9ac992'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def auto_complete_for_multisearch_query
    @objects = Species.find_with_ferret(params["multisearch"]["query"]+"*", :limit => 5, :lazy=>true, :multi => [Mature,Precursor])
    render :partial => "shared/multisearch_results"
  end
  
end
