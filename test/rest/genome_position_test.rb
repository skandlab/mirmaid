require 'test_helper_rest'

class GenomePositionTest < RestTestCase
  
  test "precursor has many genome positions" do
    assert_equal(2,GenomePosition.find(:first,:from => "/precursors/hsa-mir-10b/genome_positions").xsome.to_i)
  end

  # other tests
  test "hsa-mir-21 and cel-let-7" do
    assert_equal("17", GenomePosition.find(:first,:from=>"/precursors/hsa-mir-21/genome_positions").xsome)
    assert_equal("X", GenomePosition.find(:first,:from=>"/precursors/cel-let-7/genome_positions").xsome)
  end
end
