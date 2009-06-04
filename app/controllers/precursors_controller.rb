class PrecursorsController < ApplicationController
  layout "application"
  protect_from_forgery :only => [:create, :update, :destroy]
  
  # GET /precursors
  # GET /precursors.xml
  def index
    @precursors = nil
    
    params[:page] ||= 1
    @query = (params[:search] && params[:search][:query]) ? params[:search][:query] : ""
    
    if params[:species_id]
      @precursors = Species.find_rest(params[:species_id]).precursors
    elsif params[:mature_id]
      @precursors = [Mature.find_rest(params[:mature_id]).precursor]
    elsif params[:paper_id]
      @precursors = Paper.find_rest(params[:paper_id]).precursors
    elsif params[:precursor_family_id]
      @precursors = PrecursorFamily.find_rest(params[:precursor_family_id]).precursors
    elsif params[:precursor_cluster_id]
      @precursors = PrecursorCluster.find_rest(params[:precursor_cluster_id]).precursors
    elsif params[:precursor_external_synonym_id]
      @precursors = PrecursorExternalSynonym.find_rest(params[:precursor_external_synonym_id]).precursors
    end
    
    respond_to do |format|
      format.html do
        params[:page] ||= 1
        @query = (params[:search] && params[:search][:query]) ? params[:search][:query] : ""
    
        if @query != ""
          @query = @query.split(' ').map{|x| x+"*"}.join(' ')
          @precursors = Precursor.find_with_ferret(@query, :page => params[:page], :per_page => 12, :sort => :name_for_sort,:lazy=>true)
        else
          if @precursors # subselect
            @precursors = Precursor.paginate @precursors.map{|x| x.id}, :page => params[:page], :per_page => 12, :order => :name
          else #all
            @precursors = Precursor.paginate :page => params[:page], :per_page => 12, :order => :name
          end
        end
      end
      format.xml do
        @precursors = Precursor.find(:all) if !@precursors
        render :xml => @precursors
      end
      format.fa do
        @precursors = Precursor.find(:all) if !@precursors
        render :layout => false, :text => @precursors.sort_by{|p| p.name}.map{|p| ">#{p.name}\r\n#{p.sequence}"}.join("\r\n")
      end
    end
      
  end

  # GET /precursors/1
  # GET /precursors/1.xml
  def show
    @precursor = nil
    
    if params[:mature_id]
      @precursor = Mature.find_rest(params[:mature_id]).precursor
    else
      @precursor = Precursor.find_rest(params[:id])
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @precursor }
      format.fa { render :layout => false, :text => ">#{@precursor.name}\r\n#{@precursor.sequence}"}
    end
  end

  def auto_complete_for_search_query
    @precursors = Precursor.find_with_ferret(params["search"]["query"], :limit => 10,:lazy=>true,:sort=>:name_for_sort)
    render :partial => "search_results"
  end
 
end
