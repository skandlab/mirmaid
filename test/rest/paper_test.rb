require 'test_helper_rest'

class PaperTest < RestTestCase
  test "REST ID is medline" do
    assert_equal(11679670,Paper.find(11679670).medline)
  end

  test "mature has many papers" do
    assert_equal('"An abundant class of tiny RNAs with probable regulatory roles in Caenorhabditis elegans"',  Paper.find(:all,:from=>"/matures/cel-let-7/papers").sort_by{|x| x.medline}.first.title)
  end

  test "precursor has many papers" do
    assert_equal('"An abundant class of tiny RNAs with probable regulatory roles in Caenorhabditis elegans"',  Paper.find(:all,:from=>"/precursors/cel-let-7/papers").sort_by{|x| x.medline}.first.title)
  end

  test "species has many papers" do
    assert_equal(10642801,  Paper.find(:all,:from=>"/species/cel/papers").sort_by{|x| x.medline}.first.medline)
  end
    
end

