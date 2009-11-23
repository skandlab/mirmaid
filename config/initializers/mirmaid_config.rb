
module Mirmaid
  class Config

    def version
      1.0
    end
    
    attr :plugin_routes
    attr :plugin_resources
    attr :plugin_menu
    attr :mirbase_data_dir
    attr :mirbase_version
    attr :mirbase_local_data
    attr :mirbase_remote_data
    attr :web_relative_url_root
    attr :ferret_enabled, true
    attr :ferret_models, true
    attr :google_analytics_tracker
    attr :google_analytics_domain
    attr :log_level
   
    def initialize
      @plugin_routes = Hash.new {|h,k| h[k]=[]}
      @plugin_resources = Hash.new
      @plugin_menu = Hash.new {|h,k| h[k]=[]}
      setup = YAML.load_file(RAILS_ROOT + "/config/mirmaid_config.yml") || raise("Missing config/mirmaid_config.yml file")
      
      # mirmaid
      @log_level = setup['mirmaid']['log_level'] || "error"
      ActiveRecord::Base.logger.level = ActiveSupport::BufferedLogger.const_get(@log_level.upcase)
            
      # mirbase
      @mirbase_version = setup['mirbase']['version'] || "CURRENT"
      @mirbase_data_dir = RAILS_ROOT + "/tmp/mirbase_data/"
      @mirbase_local_data = setup['mirbase']['local_data']
      @mirbase_remote_data = setup['mirbase']['remote_data']
      
      # web
      @ferret_enabled = setup['web']['ferret']
      @ferret_models = [:species,:mature,:precursor]
      # as of passenger 2.2.3, there is no need to set
      # relative_url_root anymore: http://code.google.com/p/phusion-passenger/issues/detail?id=169
      @web_relative_url_root = setup['web']['relative_url_root']
      @google_analytics_tracker = setup['web']['google_analytics_tracker']
      @google_analytics_domain = setup['web']['google_analytics_domain']
      if @google_analytics_tracker
        Rubaidh::GoogleAnalytics.tracker_id = @google_analytics_tracker
        Rubaidh::GoogleAnalytics.domain_name = @google_analytics_domain if @google_analytics_domain
      else
        Rubaidh::GoogleAnalytics.tracker_id = "disabled"
        Rubaidh::GoogleAnalytics.formats = [] # disable
      end

      # described routes
      require 'described_routes/rails_controller'
      hide_routes = [/^ferret_search\S*$/,/^pubmed_papers$/,/^home$/,/^root$/,/^search$/]
      DescribedRoutes::RailsRoutes.parsed_hook = lambda {|a| a.reject{|h| hide_routes.any?{|x| h["name"] =~ x}}}  
    end
    
    def add_plugin_resource(plugin_name,resource,options=nil)
      @plugin_resources[resource.to_s.pluralize.to_sym] = plugin_name
      @plugin_menu[plugin_name] << resource.to_s.pluralize
    end
    
    def add_plugin_route(core_model,plugin_model,rel,options=nil)
      # we could allow override of defaults in options hash ...
      # check default parameters
      core_model.to_s.classify.constantize # raises NameError exception if class is not defined
      plugin_model.to_s.classify.constantize

      raise "error: plugin route #{core_model}<->#{plugin_model} ill defined" if rel.size != 2 or rel.select{|x| x == :one or x == :many}.size != 2
            
      rt = {:core_model=>core_model,:plugin_model=>plugin_model,:rel=>rel}
      
      # association method to access core_model from plugin_model: plugin_model.plugin_method
      rt[:plugin_method] = rel[0] == :one ? core_model.to_s : core_model.to_s.pluralize.to_s
      # association method to access plugin_model from core_model: core_model.core_method
      rt[:core_method] = rel[1] == :one ? plugin_model.to_s : plugin_model.to_s.pluralize.to_s
      
      # convention: partial to be used is list_for_class
      rt[:partial] = plugin_model.to_s.pluralize+"/"+"list_for_#{core_model}" if !rt.key?(:partial)
           
      @plugin_routes[core_model] << rt
    end
    
  end
end

MIRMAID_CONFIG = Mirmaid::Config.new()


