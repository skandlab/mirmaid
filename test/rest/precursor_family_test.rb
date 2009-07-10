require 'test_helper_rest'

class PrecursorFamilyTest < RestTestCase

  test "REST id is name" do
    assert_equal("mir-21",PrecursorFamily.find("mir-21").name)
  end

  test "precursor has one precursor family" do
    assert_not_nil(PrecursorFamily.find(:one,:from => "/precursors/hsa-mir-21/precursor_family"))
  end

  test "cel-let-7 precursor family size" do
    pf = PrecursorFamily.find(:one,:from => "/precursors/cel-let-7/precursor_family")
    ps = Precursor.find(:all, :from => "/precursor_families/#{pf.id}/precursors.xml")
    assert(ps.map{|x| x.name}.include?("cel-let-7"))
    assert((ps.size > 20 and ps.size < 5000))
  end
end

