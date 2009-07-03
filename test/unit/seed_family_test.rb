# == Schema Information
#
# Table name: seed_families
#
#  id       :integer         not null, primary key
#  name     :string(255)
#  sequence :string(255)
#

require 'test_helper'

class SeedFamilyTest < ActiveSupport::TestCase

  test "let-7 seed family" do
    assert_operator(3, :<=,SeedFamily.find_by_name('cel-GAGGUAG').matures.size)
    assert_operator(5, :<=,SeedFamily.find_by_name('hsa-GAGGUAG').matures.size)
    assert_equal(["AGGUAG", "GAGGUA", "GAGGUAG"], Mature.find_by_name('cel-let-7').seed_families.map{|x| x.sequence}.sort)
  end
  
end
