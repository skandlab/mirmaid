class PrecursorExternalSynonymsController < ApplicationController
  # GET /precursor_external_synonyms
  # GET /precursor_external_synonyms.xml
  def index
    @precursor_external_synonyms = nil
    
    if params[:precursor_id]
      @precursor_external_synonyms = Precursor.find_rest(params[:precursor_id]).precursor_external_synonyms
    else
      @precursor_external_synonyms = PrecursorExternalSynonym.find(:all)
    end

    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @precursor_external_synonyms }
    end
  end

  # GET /precursor_external_synonyms/1
  # GET /precursor_external_synonyms/1.xml
  def show
    @precursor_external_synonym = PrecursorExternalSynonym.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @precursor_external_synonym }
    end
  end

  # GET /precursor_external_synonyms/new
  # GET /precursor_external_synonyms/new.xml
  def new
    @precursor_external_synonym = PrecursorExternalSynonym.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @precursor_external_synonym }
    end
  end

  # GET /precursor_external_synonyms/1/edit
  def edit
    @precursor_external_synonym = PrecursorExternalSynonym.find(params[:id])
  end

  # POST /precursor_external_synonyms
  # POST /precursor_external_synonyms.xml
  def create
    @precursor_external_synonym = PrecursorExternalSynonym.new(params[:precursor_external_synonym])

    respond_to do |format|
      if @precursor_external_synonym.save
        flash[:notice] = 'PrecursorExternalSynonym was successfully created.'
        format.html { redirect_to(@precursor_external_synonym) }
        format.xml  { render :xml => @precursor_external_synonym, :status => :created, :location => @precursor_external_synonym }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @precursor_external_synonym.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /precursor_external_synonyms/1
  # PUT /precursor_external_synonyms/1.xml
  def update
    @precursor_external_synonym = PrecursorExternalSynonym.find(params[:id])

    respond_to do |format|
      if @precursor_external_synonym.update_attributes(params[:precursor_external_synonym])
        flash[:notice] = 'PrecursorExternalSynonym was successfully updated.'
        format.html { redirect_to(@precursor_external_synonym) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @precursor_external_synonym.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /precursor_external_synonyms/1
  # DELETE /precursor_external_synonyms/1.xml
  def destroy
    @precursor_external_synonym = PrecursorExternalSynonym.find(params[:id])
    @precursor_external_synonym.destroy

    respond_to do |format|
      format.html { redirect_to(precursor_external_synonyms_url) }
      format.xml  { head :ok }
    end
  end
end
