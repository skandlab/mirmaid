class HomeController < ApplicationController
  layout "application"
  protect_from_forgery :only => [:create, :update, :destroy]
  
  caches_page :index
  
  def index
    @title = "MirMaid"
    @mirbase_readme = File.open(RAILS_ROOT+"/public/MIRBASE_README").readlines
  end
  
end
