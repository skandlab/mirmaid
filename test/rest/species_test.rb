require 'test_helper_rest'

class SpeciesTest < RestTestCase

  test "REST id is abbreviation" do
    assert_equal("cel",Species.find("cel").abbreviation)
  end
  
  test "species attributes" do
    assert_equal("Homo sapiens", Species.find('hsa').name)
  end
  
  test "precursor has one species" do
    assert_equal("Homo sapiens", Species.find(:one, :from=> '/precursors/hsa-mir-21/species').name)
  end

  test "mature has one species" do
    assert_equal("Homo sapiens", Species.find(:one, :from=> '/matures/hsa-miR-21/species').name)
  end

  test "paper has many species" do
    assert(Species.find(:all, :from=> '/papers/11679670/species').map{|x| x.abbreviation}.include?("cel"))
  end

end
