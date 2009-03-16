# == Schema Information
# Schema version: 1
#
# Table name: genome_positions
#
#  precursor_id :integer         default(0), not null
#  xsome        :string(20)
#  contig_start :integer(8)
#  contig_end   :integer(8)
#  strand       :string(2)
#  id           :integer         not null, primary key
#

require 'test_helper'

class GenomePositionTest < ActiveSupport::TestCase
  test "hsa-mir-21 and cel-let-7" do
    assert_equal("17", Precursor.find_by_name('hsa-mir-21').genome_positions.first.xsome)
    assert_equal("X", Precursor.find_by_name('cel-let-7').genome_positions.first.xsome)
  end
end
