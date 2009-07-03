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
      # index nested resource from plugin resource
      @seed_families = plugin_routes(:seed_family,:many,params)
    end

    @seed_families = SeedFamily.find(:all) if @seed_families.nil?

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @seed_families }
    end
  end

  # GET /seed_families/1
  # GET /seed_families/1.xml
  def show
    @seed_family = nil
    @seed_family = plugin_routes(:seed_family,:one,params)
    @seed_family = SeedFamily.find_rest(params[:id]) if @seed_family.nil?

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @seed_family }
    end
  end

end
