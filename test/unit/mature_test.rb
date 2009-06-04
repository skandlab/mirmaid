# == Schema Information
# Schema version: 1
#
# Table name: matures
#
#  id           :integer         not null, primary key
#  name         :string(40)      default(""), not null
#  accession    :string(20)      default(""), not null
#  mature_from  :integer
#  mature_to    :integer
#  evidence     :text
#  experiment   :text
#  similarity   :text
#  precursor_id :integer
#

require 'test_helper'

class MatureTest < ActiveSupport::TestCase

  test "cel-let-7 mature" do
    assert_equal("UGAGGUAGUAGGUUGUAUAGUU", Mature.find_by_name('cel-let-7').sequence)
    assert_equal("experimental", Mature.find_by_name('cel-let-7').evidence)
    assert_equal("MIMAT0000001", Mature.find_by_name('cel-let-7').accession)
    assert_not_nil( Mature.find_by_name('cel-let-7').precursor)
    assert_equal("cel-let-7", Mature.find_by_name('cel-let-7').precursor.name)
    assert_equal(1, Mature.find_by_name('cel-let-7').seed_families.select{|x| x.sequence == "GAGGUAG"}.size)
  end
  
  test "unique-mature" do
    assert(Mature.find_by_name('hsa-miR-124').precursors.size >= 3)
    assert_equal(Mature.find_all_by_name('hsa-miR-124').size,1)
  end
 
end
