class PrecursorClustersController < ApplicationController
  # GET /precursor_clusters
  # GET /precursor_clusters.xml
  def index
    @precursor_clusters = nil

    if params[:precursor_id]
      @precursor_clusters = Precursor.find_rest(params[:precursor_id]).precursor_clusters
    elsif params[:species_id]
      @precursor_clusters = Species.find_rest(params[:species_id]).precursor_clusters
    else
      @precursor_clusters = PrecursorCluster.find(:all)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @precursor_clusters }
    end
  end

  # GET /precursor_clusters/1
  # GET /precursor_clusters/1.xml
  def show
    @precursor_cluster = PrecursorCluster.find_rest(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @precursor_cluster }
    end
  end

  # GET /precursor_clusters/new
  # GET /precursor_clusters/new.xml
  def new
    @precursor_cluster = PrecursorCluster.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @precursor_cluster }
    end
  end

  # GET /precursor_clusters/1/edit
  def edit
    @precursor_cluster = PrecursorCluster.find(params[:id])
  end

  # POST /precursor_clusters
  # POST /precursor_clusters.xml
  def create
    @precursor_cluster = PrecursorCluster.new(params[:precursor_cluster])

    respond_to do |format|
      if @precursor_cluster.save
        flash[:notice] = 'PrecursorCluster was successfully created.'
        format.html { redirect_to(@precursor_cluster) }
        format.xml  { render :xml => @precursor_cluster, :status => :created, :location => @precursor_cluster }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @precursor_cluster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /precursor_clusters/1
  # PUT /precursor_clusters/1.xml
  def update
    @precursor_cluster = PrecursorCluster.find(params[:id])

    respond_to do |format|
      if @precursor_cluster.update_attributes(params[:precursor_cluster])
        flash[:notice] = 'PrecursorCluster was successfully updated.'
        format.html { redirect_to(@precursor_cluster) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @precursor_cluster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /precursor_clusters/1
  # DELETE /precursor_clusters/1.xml
  def destroy
    @precursor_cluster = PrecursorCluster.find(params[:id])
    @precursor_cluster.destroy

    respond_to do |format|
      format.html { redirect_to(precursor_clusters_url) }
      format.xml  { head :ok }
    end
  end
end
