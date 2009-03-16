require 'test_helper'

class MatureTest < ActiveSupport::TestCase

  test "cel-let-7 mature" do
    assert_equal("UGAGGUAGUAGGUUGUAUAGUU", Mature.find_by_name('cel-let-7').sequence)
    assert_equal("experimental", Mature.find_by_name('cel-let-7').evidence)
    assert_equal("MIMAT0000001", Mature.find_by_name('cel-let-7').accession)
    assert_not_nil( Mature.find_by_name('cel-let-7').precursor)
    assert_equal("cel-let-7", Mature.find_by_name('cel-let-7').precursor.name)
    assert_equal(1, Mature.find_by_name('cel-let-7').seed_families.select{|x| x.sequence == "GAGGUAG"}.size)
  end

end
