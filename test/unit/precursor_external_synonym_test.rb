# == Schema Information
# Schema version: 1
#
# Table name: precursor_external_synonyms
#
#  precursor_id :integer         default(0), not null
#  db_id        :string(255)     not null
#  comment      :string(255)
#  db_link      :string(255)     not null
#  db_secondary :string(255)
#  other_params :string(255)
#

require 'test_helper'

class PrecursorExternalSynonymTest < ActiveSupport::TestCase
  test "hsa-mir-21" do
    assert_equal("MIR21", Precursor.find_by_name('hsa-mir-21').precursor_external_synonyms.select{|x| x.db_id == "HGNC"}.first.db_secondary)
  end
end
