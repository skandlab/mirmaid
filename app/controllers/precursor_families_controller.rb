class PrecursorFamiliesController < ApplicationController
  # GET /precursor_families
  # GET /precursor_families.xml
  def index
    @precursor_families = PrecursorFamily.find(:all)
        
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @precursor_families }
    end
  end

  # GET /precursor_families/1
  # GET /precursor_families/1.xml
  def show
    @precursor_family = nil

    if params[:precursor_id]
      @precursor_family = Precursor.find_rest(params[:precursor_id]).precursor_family
    else
      @precursor_family = PrecursorFamily.find_rest(params[:id])
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @precursor_family }
    end
  end

  # GET /precursor_families/new
  # GET /precursor_families/new.xml
  def new
    @precursor_family = PrecursorFamily.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @precursor_family }
    end
  end

  # GET /precursor_families/1/edit
  def edit
    @precursor_family = PrecursorFamily.find(params[:id])
  end

  # POST /precursor_families
  # POST /precursor_families.xml
  def create
    @precursor_family = PrecursorFamily.new(params[:precursor_family])

    respond_to do |format|
      if @precursor_family.save
        flash[:notice] = 'PrecursorFamily was successfully created.'
        format.html { redirect_to(@precursor_family) }
        format.xml  { render :xml => @precursor_family, :status => :created, :location => @precursor_family }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @precursor_family.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /precursor_families/1
  # PUT /precursor_families/1.xml
  def update
    @precursor_family = PrecursorFamily.find(params[:id])

    respond_to do |format|
      if @precursor_family.update_attributes(params[:precursor_family])
        flash[:notice] = 'PrecursorFamily was successfully updated.'
        format.html { redirect_to(@precursor_family) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @precursor_family.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /precursor_families/1
  # DELETE /precursor_families/1.xml
  def destroy
    @precursor_family = PrecursorFamily.find(params[:id])
    @precursor_family.destroy

    respond_to do |format|
      format.html { redirect_to(precursor_families_url) }
      format.xml  { head :ok }
    end
  end
end
