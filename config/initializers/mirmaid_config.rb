
module Mirmaid
  class Config

    attr :mirbase_data_dir
    attr :mirbase_version
    attr :mirbase_local_data
    attr :mirbase_remote_data
    attr :web_relative_url_root
    attr :ferret_enabled, true
    attr :ferret_models, true
    
    def initialize
      setup = YAML.load_file(RAILS_ROOT + "/config/mirmaid_config.yml") || raise("Missing config/mirmaid_config.yml file")
      @mirbase_version = setup['mirbase']['version'] || "CURRENT"
      @mirbase_data_dir = RAILS_ROOT + "/tmp/mirbase_data/"
      @mirbase_local_data = setup['mirbase']['local_data']
      @mirbase_remote_data = setup['mirbase']['remote_data']
      
      # Ferret config
      @ferret_enabled = setup['ferret']['enabled']
      @ferret_models = [Species,Mature,Precursor]

      # webserver
      @web_relative_url_root = setup['web']['relative_url_root']
            
    end
    
  end
end

MIRMAID_CONFIG = Mirmaid::Config.new()

@config.action_controller.relative_url_root = MIRMAID_CONFIG.web_relative_url_root if !MIRMAID_CONFIG.web_relative_url_root.nil?

#overload ferret_enabled?
#class ActiveRecord::Base
#  def self.ferret_enabled?
#    MIRMAID_CONFIG.ferret_enabled
#  end
#end
