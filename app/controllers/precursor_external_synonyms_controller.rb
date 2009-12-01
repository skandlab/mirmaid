class PrecursorExternalSynonymsController < ApplicationController
  layout "application"
  # GET /precursor_external_synonyms
  # GET /precursor_external_synonyms.xml
  def index
    @precursor_external_synonyms = nil
    
    if params[:precursor_id]
      @precursor_external_synonyms = Precursor.find_rest(params[:precursor_id]).precursor_external_synonyms
    else
      # index nested resource from plugin resource
      @precursor_external_synonyms = find_from_plugin_routes(:precursor_external_synonym,:many,params)
    end
    
    @precursor_external_synonyms = PrecursorExternalSynonym.find(:all) if @precursor_external_synonyms.nil?
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @precursor_external_synonyms.to_xml(:only => PrecursorExternalSynonym.column_names) }
    end
  end

  # GET /precursor_external_synonyms/1
  # GET /precursor_external_synonyms/1.xml
  def show
    @precursor_external_synonym = nil
    @precursor_external_synonym = find_from_plugin_routes(:precursor_external_synonym,:one,params)
    @precursor_external_synonym = PrecursorExternalSynonym.find(params[:id]) if @precursor_external_synonym.nil?
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @precursor_external_synonym.to_xml(:only => PrecursorExternalSynonym.column_names) }
    end
  end
  
end
