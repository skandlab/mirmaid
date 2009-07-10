# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery #:secret => '150a59e42e74cf3e40d571817d9ac992'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
    
  private

  def find_from_plugin_routes(model,rel,params)

    MIRMAID_CONFIG.plugin_routes[model].each do |pr|
      next if pr[:rel][0] != rel

      extid = params[pr[:plugin_model].to_s+"_id"]
      if extid
        return pr[:plugin_model].to_s.classify.constantize.find_rest(extid).send(pr[:plugin_method])
      end
    end

    return nil
    
  end
    
end
