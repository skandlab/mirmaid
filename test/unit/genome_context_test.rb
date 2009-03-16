# == Schema Information
# Schema version: 1
#
# Table name: genome_contexts
#
#  precursor_id      :integer         default(0), not null
#  transcript_id     :string(50)
#  overlap_sense     :string(2)
#  overlap_type      :string(20)
#  number            :integer
#  transcript_source :string(50)
#  transcript_name   :string(50)
#

require 'test_helper'

class GenomeContextTest < ActiveSupport::TestCase
  test "hsa-mir-10b" do
    assert_equal("intron", Precursor.find_by_name('hsa-mir-10b').genome_contexts.select{|x| x.transcript_name =~ /HOXD3/}.first.overlap_type)
  end
  test "hsa-mir-155" do
    assert_not_nil(Precursor.find_by_name('hsa-mir-155').genome_contexts.select{|x| x.overlap_type == "exon"})
  end   
end
