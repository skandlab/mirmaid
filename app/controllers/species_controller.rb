class SpeciesController < ApplicationController
  layout "application"
  protect_from_forgery :only => [:create, :update, :destroy]

  # GET /species
  # GET /species.xml
  def index
    @species = nil
    
    if params[:paper_id]
      @species = Paper.find_rest(params[:paper_id]).species
    end

    respond_to do |format|
      format.html do
        params[:page] ||= 1
        @query = (params[:search] && params[:search][:query]) ? params[:search][:query] : ""
        
        if @query != ""
          @query = @query.split(' ').map{|x| x+"*"}.join(' ')
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
        render :xml => @species
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
      @species = Species.find_rest(params[:id])
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @species }
    end
  end
  
  def auto_complete_for_search_query
    @species = Species.find_with_ferret(params["search"]["query"], :limit => 10, :lazy=>true, :sort => :name_for_sort)
    render :partial => "search_results"
  end
  
end
