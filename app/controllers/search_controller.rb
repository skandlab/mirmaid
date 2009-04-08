class SearchController < ApplicationController
  layout "application"
  protect_from_forgery :only => [:create, :update, :destroy]
  
  def index
    @objects = WillPaginate::Collection.new(1,12,0) 
    
    if !params[:format] || params[:format] == "html"
      params[:page] ||= 1
      @query = (params[:search] && params[:search][:query]) ? params[:search][:query] : ""
      @query = params[:multisearch][:query] if (@query.empty? && (params[:multisearch] && params[:multisearch][:query]))
    
      if @query != ""
        @query = @query.split(' ').map{|x| x+"*"}.join(' ')
        @objects = Species.find_with_ferret(@query, :page => params[:page], :per_page => 12,:lazy=>true,:multi => [Mature,Precursor])
      end
    end
        
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @objects }
    end
  end

  def auto_complete_for_search_query
    @objects = Species.find_with_ferret(params["search"]["query"]+"*", :limit => 5, :lazy=>true, :multi => [Mature,Precursor])
    render :partial => "search_results"
  end
    
end
