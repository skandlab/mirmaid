class GenomeContextsController < ApplicationController
  # GET /genome_contexts
  # GET /genome_contexts.xml
  def index
    @genome_contexts = nil

    if params[:precursor_id]
      @genome_contexts = Precursor.find_rest(params[:precursor_id]).genome_contexts
    else
      # index nested resource from plugin resource
      @genome_contexts = find_from_plugin_routes(:genome_context,:many,params)
    end
    
    @genome_contexts = GenomeContext.find(:all) if @genome_contexts.nil?
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @genome_contexts.to_xml(:only => GenomeContext.column_names) }
    end
  end

  # GET /genome_contexts/1
  # GET /genome_contexts/1.xml
  def show
    @genome_context = nil
    @genome_context = find_from_plugin_routes(:genome_context,:one,params)
    @genome_context = GenomeContext.find(params[:id]) if @genome_context.nil?

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @genome_context }
    end
  end

  # GET /genome_contexts/new
  # GET /genome_contexts/new.xml
  def new
    @genome_context = GenomeContext.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @genome_context.to_xml(:only => GenomeContext.column_names) }
    end
  end

  # GET /genome_contexts/1/edit
  def edit
    @genome_context = GenomeContext.find(params[:id])
  end

  # POST /genome_contexts
  # POST /genome_contexts.xml
  def create
    @genome_context = GenomeContext.new(params[:genome_context])

    respond_to do |format|
      if @genome_context.save
        flash[:notice] = 'GenomeContext was successfully created.'
        format.html { redirect_to(@genome_context) }
        format.xml  { render :xml => @genome_context, :status => :created, :location => @genome_context }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @genome_context.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /genome_contexts/1
  # PUT /genome_contexts/1.xml
  def update
    @genome_context = GenomeContext.find(params[:id])

    respond_to do |format|
      if @genome_context.update_attributes(params[:genome_context])
        flash[:notice] = 'GenomeContext was successfully updated.'
        format.html { redirect_to(@genome_context) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @genome_context.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /genome_contexts/1
  # DELETE /genome_contexts/1.xml
  def destroy
    @genome_context = GenomeContext.find(params[:id])
    @genome_context.destroy

    respond_to do |format|
      format.html { redirect_to(genome_contexts_url) }
      format.xml  { head :ok }
    end
  end
end
