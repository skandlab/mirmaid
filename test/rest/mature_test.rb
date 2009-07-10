require 'test_helper_rest'

class MatureTest < RestTestCase

  test "REST id is name" do
    assert_equal("cel-let-7",Mature.find("cel-let-7").name)
  end
  
  test "mature attributes" do
    assert_equal("UGAGGUAGUAGGUUGUAUAGUU", Mature.find('cel-let-7').sequence)
    assert_equal("experimental", Mature.find('cel-let-7').evidence)
    assert_equal("MIMAT0000001", Mature.find('cel-let-7').accession)
  end

  test "precursor has many matures" do
    assert_equal(2,Mature.find(:all,:from=>"/precursors/hsa-mir-21/matures").size)
  end
  
  test "paper has many matures" do
    num = Mature.find(:all,:from=>"/papers/11679670/matures").size
    assert_operator 10, :<, num
    assert_operator 1000, :>, num
  end
  
  test "seed family has many matures" do
    assert_equal(2,Mature.find(:all,:from=>"/seed_families/hsa-AGCUUAU/matures").size)
  end
  
  test "species has many matures" do
    num = Mature.find(:all,:from=>"/species/cel/matures").size
    assert_operator 50, :<, num
    assert_operator 2000, :>, num
  end
  
  test "more tests" do
    assert_equal("cel-let-7", Precursor.find(:first, :from => "/matures/cel-let-7/precursors").name)
    assert_equal(1, SeedFamily.find(:all,:params => {:mature_id => 'cel-let-7'}).select{|x| x.sequence == "GAGGUAG"}.size)
    assert(Precursor.find(:all, :from => "/matures/hsa-miR-124/precursors").size >= 3)
  end

end
