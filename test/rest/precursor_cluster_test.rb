require 'test_helper_rest'

class PrecursorClusterTest < RestTestCase
  
  test "REST id is name" do
    assert_equal("cel-let-7-1kb",PrecursorCluster.find("cel-let-7-1kb").name)
  end
  
  test "precursor has many precursor clusters" do
    assert(PrecursorCluster.find(:all,:from => "/precursors/cel-let-7/precursor_clusters").size > 1)
  end

  # more tests
  test "hsa-mir-34b/c cluster" do
    assert_equal(2, PrecursorCluster.find(:all,:from => "/precursors/hsa-mir-34b/precursor_clusters").select{|x| x.name =~ /-1kb/}.size)
  end
end
