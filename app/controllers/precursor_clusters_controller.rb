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
      # index nested resource from plugin resource
      @precursor_clusters = plugin_routes(:precursor_cluster,:many,params)
    end
      
    @precursor_clusters = PrecursorCluster.find(:all) if @precursor_clusters.nil?

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @precursor_clusters }
    end
  end

  # GET /precursor_clusters/1
  # GET /precursor_clusters/1.xml
  def show
    @precursor_cluster = nil
    @precursor_cluster = plugin_routes(:precursor_cluster,:one,params)
    @precursor_cluster = PrecursorCluster.find_rest(params[:id]) if @precursor_cluster.nil?

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @precursor_cluster }
    end
  end

end
