
module Mirmaid
  class Config

    attr :mirbase_data_dir
    attr :mirbase_version
    attr :mirbase_local_data
    attr :mirbase_remote_data
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
    end
    
  end
end

MIRMAID_CONFIG = Mirmaid::Config.new()

#overload ferret_enabled?
#class ActiveRecord::Base
#  def self.ferret_enabled?
#    MIRMAID_CONFIG.ferret_enabled
#  end
#end
