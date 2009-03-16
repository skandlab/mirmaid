require 'test_helper'

class SpeciesTest < ActiveSupport::TestCase
  
  test "hsa species" do
    assert_equal(Species.find_rest('hsa'), Species.find_by_abbreviation('hsa'))
    assert_equal("Homo sapiens", Species.find_by_abbreviation('hsa').name)
  end

end
