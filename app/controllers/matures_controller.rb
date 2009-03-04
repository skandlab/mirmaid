class MaturesController < ApplicationController

#  before_filter :find_precursor

  # GET /matures
  # GET /matures.xml
  def index
    @matures = nil

    if params[:precursor_id]
      @matures = Precursor.find_rest(params[:precursor_id]).matures
    elsif params[:species_id]
      @matures = Species.find_rest(params[:species_id]).matures
    elsif params[:paper_id]
      @matures = Paper.find_rest(params[:paper_id]).matures
    else
      @matures = Mature.find(:all)
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
