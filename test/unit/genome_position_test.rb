require 'test_helper'

class GenomePositionTest < ActiveSupport::TestCase
  test "hsa-mir-21 and cel-let-7" do
    assert_equal("17", Precursor.find_by_name('hsa-mir-21').genome_positions.first.xsome)
    assert_equal("X", Precursor.find_by_name('cel-let-7').genome_positions.first.xsome)
  end
end
