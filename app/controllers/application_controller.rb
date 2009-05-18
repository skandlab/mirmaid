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
    @objects = Species.find_with_ferret(params["multisearch"]["query"]+"*", :limit => 15, :lazy=>true, :multi => [Species,Mature,Precursor], :sort => :name_for_sort)
    render :partial => "shared/multisearch_results"
  end

  def pubmed_papers
    query = params[:query]
    limit = params[:limit] || 5
    @div = params[:div] || "pubmed_papers"
    @partial = "shared/pubmed_papers"
    @object = Bio::PubMed.search(query)[0,limit].map{|x| Bio::MEDLINE.new(Bio::PubMed.efetch(x))}
    render :partial => "shared/update"
  end
  
end
