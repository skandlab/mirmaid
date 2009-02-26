class GenomePositionsController < ApplicationController
  # GET /genome_positions
  # GET /genome_positions.xml
  def index
    @genome_positions = GenomePosition.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @genome_positions }
    end
  end

  # GET /genome_positions/1
  # GET /genome_positions/1.xml
  def show
    @genome_position = GenomePosition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @genome_position }
    end
  end

  # GET /genome_positions/new
  # GET /genome_positions/new.xml
  def new
    @genome_position = GenomePosition.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @genome_position }
    end
  end

  # GET /genome_positions/1/edit
  def edit
    @genome_position = GenomePosition.find(params[:id])
  end

  # POST /genome_positions
  # POST /genome_positions.xml
  def create
    @genome_position = GenomePosition.new(params[:genome_position])

    respond_to do |format|
      if @genome_position.save
        flash[:notice] = 'GenomePosition was successfully created.'
        format.html { redirect_to(@genome_position) }
        format.xml  { render :xml => @genome_position, :status => :created, :location => @genome_position }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @genome_position.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /genome_positions/1
  # PUT /genome_positions/1.xml
  def update
    @genome_position = GenomePosition.find(params[:id])

    respond_to do |format|
      if @genome_position.update_attributes(params[:genome_position])
        flash[:notice] = 'GenomePosition was successfully updated.'
        format.html { redirect_to(@genome_position) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @genome_position.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /genome_positions/1
  # DELETE /genome_positions/1.xml
  def destroy
    @genome_position = GenomePosition.find(params[:id])
    @genome_position.destroy

    respond_to do |format|
      format.html { redirect_to(genome_positions_url) }
      format.xml  { head :ok }
    end
  end
end
