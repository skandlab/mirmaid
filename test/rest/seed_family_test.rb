require 'test_helper_rest'

class SeedFamilyTest < RestTestCase
  
  test "REST id is species+seq" do
    assert_equal("AGCUUAU",SeedFamily.find("hsa-AGCUUAU").sequence) # mir-21
  end
  
  test "mature has many seed families" do
    assert(SeedFamily.find(:all, :from => "/matures/hsa-miR-21/seed_families").size > 2)
  end

  test "species has many seed families" do
    assert(SeedFamily.find(:all, :from => "/species/cel/seed_families").size > 50)
  end
  
  test "more tests" do
    assert(Mature.find(:all, :from => "/seed_families/#{SeedFamily.find('cel-GAGGUAG').id}/matures").size < 50)
    assert(Mature.find(:all, :from => "/seed_families/#{SeedFamily.find('hsa-GAGGUAG').id}/matures").size > 3)
    assert_equal(["AGGUAG", "GAGGUA", "GAGGUAG"], SeedFamily.find(:all, :from => "/matures/cel-let-7/seed_families").map{|x| x.sequence}.sort)
  end

end
