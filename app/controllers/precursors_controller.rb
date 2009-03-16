class PrecursorsController < ApplicationController
  # GET /precursors
  # GET /precursors.xml
  def index
    @precursors = nil
    
    if params[:species_id]
      @precursors = Species.find_rest(params[:species_id]).precursors
    elsif params[:paper_id]
      @precursors = Paper.find_rest(params[:paper_id]).precursors
    elsif params[:precursor_family_id]
      @precursors = PrecursorFamily.find_rest(params[:precursor_family_id]).precursors
    elsif params[:precursor_cluster_id]
      @precursors = PrecursorCluster.find_rest(params[:precursor_cluster_id]).precursors
    else
      @precursors = Precursor.find(:all)
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
