require 'test_helper_rest'

class PrecursorExternalSynonymTest < RestTestCase
  test "precursor has many external synonyms" do
    assert(PrecursorExternalSynonym.find(:all,:from=>"/precursors/hsa-mir-21/precursor_external_synonyms").select{|x| x.db_id == "HGNC"}.first.db_secondary =~ /MIR.*21/)
  end
end

