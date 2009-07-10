class SpeciesController < ApplicationController
  layout "application"
  protect_from_forgery :only => [:create, :update, :destroy]

  # GET /species
  # GET /species.xml
  def index
    @species = nil
    
    if params[:paper_id]
      @species = Paper.find_rest(params[:paper_id]).species
    else
      # index nested resource from plugin resource
      @species = find_from_plugin_routes(:species,:many,params)
    end

    respond_to do |format|
      format.html do
        params[:page] ||= 1
        @query = (params[:search] && params[:search][:query]) ? params[:search][:query] : ""
        
        if @query != ""
          @species = Species.find_with_ferret(@query, :page => params[:page], :per_page => 12,:sort => :taxonomy_for_sort,:lazy=>true)
        else
          if @species # subselect
            @species = Species.paginate @species.map{|x| x.id}, :page => params[:page], :per_page => 12, :order => :taxonomy
          else #all
            @species = Species.paginate :page => params[:page], :per_page => 12, :order => :taxonomy
          end
        end
      end
      format.xml do
        @species = Species.find(:all) if !@species
        render :xml => @species.to_xml(:only => Species.column_names)
      end
    end       
    
  end
  
  # GET /species/1
  # GET /species/1.xml
  def show
    @species = nil
    
    if params[:precursor_id]
      @species = Precursor.find_rest(params[:precursor_id]).species
    elsif params[:mature_id]
      @species = Mature.find_rest(params[:mature_id]).precursor.species
    else
      # show nested resource from plugin resource
      @species = find_from_plugin_routes(:species,:one,params)
    end

    @species = Species.find_rest(params[:id]) if @species.nil?
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @species.to_xml(:only => Species.column_names) }
    end
  end
  
  def ferret_search
    @query = params["search"]["query"]
    @species = Species.find_with_ferret(@query, :limit => 15, :lazy=>true, :sort => :name_for_sort)
    render :partial => "search_results"
  end
  
end
