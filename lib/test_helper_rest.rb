#ENV["RAILS_ENV"] = "development" # use rails env
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'activeresource'

MIRMAID_URL = ENV['MIRMAID_URL']

class RestTestCase < ActiveSupport::TestCase

  class Mature < ActiveResource::Base
    self.site = MIRMAID_URL
  end

  class Precursor < ActiveResource::Base
    self.site = MIRMAID_URL
  end

  class Species < ActiveResource::Base
    self.site = MIRMAID_URL
  end
  
  class Paper < ActiveResource::Base
    self.site = MIRMAID_URL
  end
  
  class GenomeContext < ActiveResource::Base
    self.site = MIRMAID_URL
  end

  class GenomePosition < ActiveResource::Base
    self.site = MIRMAID_URL
  end

  class PrecursorCluster < ActiveResource::Base
    self.site = MIRMAID_URL
  end
  
  class PrecursorExternalSynonym < ActiveResource::Base
    self.site = MIRMAID_URL
  end

  class PrecursorFamily < ActiveResource::Base
    self.site = MIRMAID_URL
  end

  class SeedFamily < ActiveResource::Base
    self.site = MIRMAID_URL
  end
    
end


