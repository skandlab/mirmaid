# == Schema Information
# Schema version: 1
#
# Table name: precursors
#
#  id                  :integer         not null, primary key
#  accession           :string(9)       default(""), not null
#  name                :string(40)      default(""), not null
#  description         :string(100)
#  sequence            :text
#  comment             :text
#  species_id          :integer         default(0), not null
#  precursor_family_id :integer
#

require 'test_helper'

class PrecursorTest < ActiveSupport::TestCase
  
  test "precursor REST finder" do
    assert_equal(Precursor.find_rest('hsa-mir-21'),Precursor.find_by_name('hsa-mir-21'))
  end
  
  test "precursor model" do
    assert_equal("MI0000077",Precursor.find_by_name('hsa-mir-21').accession)
  end

  test "precursor <-> species" do
    assert_equal("Homo sapiens",Precursor.find_by_name('hsa-mir-21').species.name)
    assert(Species.find_by_abbreviation('hsa').precursors.size > 50)
  end

  test "precursor <-> precursor_family" do
    assert(Precursor.find_by_name('hsa-mir-21').precursor_family.precursors.size > 0)
  end
  
  test "precursor <-> paper" do
    assert(Precursor.find_by_name('hsa-mir-21').papers.first.precursors.size > 0)
  end
  
  test "precursor <-> precursor_cluster" do
    assert(Precursor.find_by_name('hsa-mir-34b').precursor_clusters.first.precursors.size > 1)
  end
  
  test "precursor <-> precursor_external_synonym" do
    assert_equal(Precursor.find_by_name('hsa-mir-21'),Precursor.find_by_name('hsa-mir-21').precursor_external_synonyms.first.precursor)
  end
  
  test "precursor <-> genome_context" do
    assert_equal(Precursor.find_by_name('hsa-mir-10b'),Precursor.find_by_name('hsa-mir-10b').genome_contexts.first.precursor)
  end
  
  test "precursor <-> genome_position" do
    assert_equal(Precursor.find_by_name('hsa-mir-21'),Precursor.find_by_name('hsa-mir-21').genome_positions.first.precursor)
  end
  
  test "precursor <-> mature" do
    assert_equal(Precursor.find_by_name('hsa-mir-21'),Precursor.find_by_name('hsa-mir-21').matures.first.precursor)
  end
  
end
