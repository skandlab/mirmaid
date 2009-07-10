require 'test_helper_rest'

class PrecursorTest < RestTestCase
  
  test "REST id is name" do
    assert_equal("cel-let-7",Precursor.find("cel-let-7").name)
  end
  
  test "precursor attributes" do
    assert_equal("MI0000077",Precursor.find('hsa-mir-21').accession)
  end
  
  test "species has many precursors" do
    num = Precursor.find(:all,:from => "/species/cel/precursors").size
    assert_operator 50, :<, num
    assert_operator 2000, :>, num
  end
  
  test "matures has many precursors" do
    assert_equal(2,Precursor.find(:all,:from=>"/matures/hsa-miR-1/precursors").size)
    assert_equal(1,Precursor.find(:all,:from=>"/matures/hsa-miR-21/precursors").size)
  end
  
  test "precursor family has many precursors" do
    assert(Precursor.find(:all, :from => "/precursor_families/mir-21/precursors").size > 15)
  end

  test "paper has many precursors" do
    assert(Precursor.find(:all, :from => "/papers/11679670/precursors").size > 20)
  end
  
  test "precursor cluster has many precursors" do
    # 34-b and c should cluster together
    assert(Precursor.find(:all,:from => "/precursor_clusters/hsa-mir-34b-1kb/precursors").size > 1)
  end
  
  test "more tests" do
    assert_equal("Homo sapiens",Species.find(1,:params => {:precursor_id=>'hsa-mir-21'}).name)
    assert_equal(Precursor.find('hsa-mir-21').sequence,Precursor.find(:first, :params => {:mature_id => 'hsa-miR-21'}).sequence)
    assert(Paper.find(:all,:params=>{:precursor_id => 'hsa-mir-21'}).size > 0)
  end

end
