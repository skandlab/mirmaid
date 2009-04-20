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
    elsif params[:paper_id]
      @precursors = Paper.find_rest(params[:paper_id]).precursors
    elsif params[:precursor_family_id]
      @precursors = PrecursorFamily.find_rest(params[:precursor_family_id]).precursors
    elsif params[:precursor_cluster_id]
      @precursors = PrecursorCluster.find_rest(params[:precursor_cluster_id]).precursors
    end
    
    if !params[:format] || params[:format] == "html"
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
    else # xml
      @precursors = Precursor.find(:all) if !@precursors
    end
      
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @precursors }
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
    end
  end

  def auto_complete_for_search_query
    @precursors = Precursor.find_with_ferret(params["search"]["query"]+"*", :limit => 10,:lazy=>true,:sort=>:name_for_sort)
    render :partial => "search_results"
  end
 
  ### DISABLED
  
  # GET /precursors/new
  # GET /precursors/new.xml
  def new
    @precursor = Precursor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @precursor }
    end
  end

  # GET /precursors/1/edit
  def edit
    @precursor = Precursor.find(params[:id])
  end

  # POST /precursors
  # POST /precursors.xml
  def create
    @precursor = Precursor.new(params[:precursor])

    respond_to do |format|
      if @precursor.save
        flash[:notice] = 'Precursor was successfully created.'
        format.html { redirect_to(@precursor) }
        format.xml  { render :xml => @precursor, :status => :created, :location => @precursor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @precursor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /precursors/1
  # PUT /precursors/1.xml
  def update
    @precursor = Precursor.find(params[:id])

    respond_to do |format|
      if @precursor.update_attributes(params[:precursor])
        flash[:notice] = 'Precursor was successfully updated.'
        format.html { redirect_to(@precursor) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @precursor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /precursors/1
  # DELETE /precursors/1.xml
  def destroy
    @precursor = Precursor.find(params[:id])
    @precursor.destroy

    respond_to do |format|
      format.html { redirect_to(precursors_url) }
      format.xml  { head :ok }
    end
  end
end
