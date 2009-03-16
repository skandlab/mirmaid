# == Schema Information
# Schema version: 1
#
# Table name: species
#
#  id              :integer(8)      not null, primary key
#  abbreviation    :string(10)
#  division        :string(10)
#  name            :string(100)
#  taxonomy        :string(200)
#  genome_assembly :string(15)
#  ensembl_db      :string(50)
#

require 'test_helper'

class SpeciesTest < ActiveSupport::TestCase
  
  test "hsa species" do
    assert_equal(Species.find_rest('hsa'), Species.find_by_abbreviation('hsa'))
    assert_equal("Homo sapiens", Species.find_by_abbreviation('hsa').name)
  end

end
