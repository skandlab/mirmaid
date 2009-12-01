class GenomePositionsController < ApplicationController
  layout "application"
  # GET /genome_positions
  # GET /genome_positions.xml
  def index
    @genome_positions = nil
    
    if params[:precursor_id]
      @genome_positions = Precursor.find_rest(params[:precursor_id]).genome_positions
    else
      # index nested resource from plugin resource
      @genome_positions = find_from_plugin_routes(:genome_position,:many,params)
    end      

    @genome_positions = GenomePosition.find(:all) if @genome_positions.nil?
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @genome_positions.to_xml(:only => GenomePosition.column_names) }
    end
  end

  # GET /genome_positions/1
  # GET /genome_positions/1.xml
  def show
    @genome_position = nil
    @genome_position = find_from_plugin_routes(:genome_position,:one,params)
    @genome_position = GenomePosition.find(params[:id]) if @genome_position.nil?

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @genome_position.to_xml(:only => GenomePosition.column_names) }
    end
  end

end
