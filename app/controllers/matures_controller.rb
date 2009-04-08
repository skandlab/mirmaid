class MaturesController < ApplicationController
  layout "application"
  protect_from_forgery :only => [:create, :update, :destroy]
  
  # GET /matures
  # GET /matures.xml
  def index
    @matures = nil
    
    params[:page] ||= 1
    @query = (params[:search] && params[:search][:query]) ? params[:search][:query] : ""
    
    if params[:precursor_id]
      @matures = Precursor.find_rest(params[:precursor_id]).matures
    elsif params[:species_id]
      @matures = Species.find_rest(params[:species_id]).matures
    elsif params[:paper_id]
      @matures = Paper.find_rest(params[:paper_id]).matures
    elsif params[:seed_family_id]
      @matures = SeedFamily.find_rest(params[:seed_family_id]).matures
    end  
    
    if !params[:format] || params[:format] == "html"
      params[:page] ||= 1
      @query = (params[:search] && params[:search][:query]) ? params[:search][:query] : ""
      
      if @query != ""
        @query = @query.split(' ').map{|x| x+"*"}.join(' ')
        @matures = Mature.find_with_ferret(@query, :page => params[:page], :per_page => 12, :sort => :name_for_sort,:lazy => true)
      else
        if @matures # subselect
          @matures = Mature.paginate @matures.map{|x| x.id}, :page => params[:page], :per_page => 12, :order => :name
        else #all
          @matures = Mature.paginate :page => params[:page], :per_page => 12, :order => :name
        end
      end
    else # xml
      @matures = Matures.find(:all) if !@matures
    end

    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @matures }
    end
  end

  # GET /matures/1
  # GET /matures/1.xml
  def show
    @mature = Mature.find_rest(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mature }
    end
  end

  def auto_complete_for_search_query
    @matures = Mature.find_with_ferret(params["search"]["query"]+"*", :limit => 5, :lazy=>true, :sort => :name_for_sort)
    render :partial => "search_results"
  end
  
  ### DISABLED ...
  
  # GET /matures/new
  # GET /matures/new.xml
  def new
    @mature = Mature.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mature }
    end
  end

  # GET /matures/1/edit
  def edit
    @mature = Mature.find(params[:id])
  end

  # POST /matures
  # POST /matures.xml
  def create
    @mature = Mature.new(params[:mature])

    respond_to do |format|
      if @mature.save
        flash[:notice] = 'Mature was successfully created.'
        format.html { redirect_to(@mature) }
        format.xml  { render :xml => @mature, :status => :created, :location => @mature }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /matures/1
  # PUT /matures/1.xml
  def update
    @mature = Mature.find(params[:id])

    respond_to do |format|
      if @mature.update_attributes(params[:mature])
        flash[:notice] = 'Mature was successfully updated.'
        format.html { redirect_to(@mature) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /matures/1
  # DELETE /matures/1.xml
  def destroy
    @mature = Mature.find(params[:id])
    @mature.destroy

    respond_to do |format|
      format.html { redirect_to(matures_url) }
      format.xml  { head :ok }
    end
  end
  
  #protected

  #def find_precursor
  #  Precursor.find()
  #end
 
end
