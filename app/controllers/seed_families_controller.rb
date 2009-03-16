class SeedFamiliesController < ApplicationController
  # GET /seed_families
  # GET /seed_families.xml
  def index
    @seed_families = nil

    if params[:mature_id]
      @seed_families = Mature.find_rest(params[:mature_id]).seed_families
    elsif params[:species_id]
      @seed_families = Species.find_rest(params[:species_id]).seed_families
    else
      @seed_families = SeedFamily.find(:all)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @seed_families }
    end
  end

  # GET /seed_families/1
  # GET /seed_families/1.xml
  def show
    @seed_family = SeedFamily.find_rest(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @seed_family }
    end
  end

  # GET /seed_families/new
  # GET /seed_families/new.xml
  def new
    @seed_family = SeedFamily.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @seed_family }
    end
  end

  # GET /seed_families/1/edit
  def edit
    @seed_family = SeedFamily.find(params[:id])
  end

  # POST /seed_families
  # POST /seed_families.xml
  def create
    @seed_family = SeedFamily.new(params[:seed_family])

    respond_to do |format|
      if @seed_family.save
        flash[:notice] = 'SeedFamily was successfully created.'
        format.html { redirect_to(@seed_family) }
        format.xml  { render :xml => @seed_family, :status => :created, :location => @seed_family }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @seed_family.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /seed_families/1
  # PUT /seed_families/1.xml
  def update
    @seed_family = SeedFamily.find(params[:id])

    respond_to do |format|
      if @seed_family.update_attributes(params[:seed_family])
        flash[:notice] = 'SeedFamily was successfully updated.'
        format.html { redirect_to(@seed_family) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @seed_family.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /seed_families/1
  # DELETE /seed_families/1.xml
  def destroy
    @seed_family = SeedFamily.find(params[:id])
    @seed_family.destroy

    respond_to do |format|
      format.html { redirect_to(seed_families_url) }
      format.xml  { head :ok }
    end
  end
end
