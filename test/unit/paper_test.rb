require 'test_helper'

class PaperTest < ActiveSupport::TestCase
  test "first cel-let-7 paper" do
    assert_equal('"An abundant class of tiny RNAs with probable regulatory roles in Caenorhabditis elegans"',  Mature.find_by_name('cel-let-7').papers.sort_by{|x| x.medline}.first.title)
  end
end
