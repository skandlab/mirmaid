require 'test_helper'

class PrecursorExternalSynonymTest < ActiveSupport::TestCase
  test "hsa-mir-21" do
    assert_equal("MIR21", Precursor.find_by_name('hsa-mir-21').precursor_external_synonyms.select{|x| x.db_id == "HGNC"}.first.db_secondary)
  end
end
