require 'test_helper_rest'

class GenomeContextTest < RestTestCase

  test "precursor has many genome contexts" do
    assert(GenomeContext.find(:all,:from => "/precursors/hsa-mir-10b/genome_contexts").size > 0)
  end
  
  # other tests
  test "hsa-mir-10b" do
    assert_equal("intron", GenomeContext.find(:all,:from=>"/precursors/hsa-mir-10b/genome_contexts").select{|x| x.transcript_name =~ /HOXD3/}.first.overlap_type)
  end
  test "hsa-mir-155" do
    assert_not_nil(GenomeContext.find(:all,:from=>"/precursors/hsa-mir-155/genome_contexts").select{|x| x.overlap_type == "exon"})
  end
end
