class PapersController < ApplicationController
  # GET /papers
  # GET /papers.xml
  def index
    @papers = nil
    
    if params[:precursor_id]
      @papers = Precursor.find_rest(params[:precursor_id]).papers
    elsif params[:mature_id]
      @papers = Mature.find_rest(params[:mature_id]).papers
    elsif params[:species_id]
      @papers = Species.find_rest(params[:species_id]).papers
    else
      # index nested resource from plugin resource
      @papers = find_from_plugin_routes(:paper,:many,params)
    end

    @papers = Paper.find(:all) if @papers.nil?
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @papers.to_xml(:only => Paper.column_names) }
    end
  end

  # GET /papers/1
  # GET /papers/1.xml
  def show
    @paper = nil
    @paper = find_from_plugin_routes(:paper,:one,params)
    @paper = Paper.find_rest(params[:id]) if @paper.nil?
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paper.to_xml(:only => Paper.column_names) }
    end
  end
  
end
