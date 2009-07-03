# == Schema Information
#
# Table name: precursor_clusters
#
#  id   :integer         not null, primary key
#  name :string(255)
#

require 'test_helper'

class PrecursorClusterTest < ActiveSupport::TestCase

  test "hsa-mir-34b/c cluster" do
    assert_equal(2, Precursor.find_by_name('hsa-mir-34b').precursor_clusters.select{|x| x.name =~ /-1kb/}.size)
  end
end
