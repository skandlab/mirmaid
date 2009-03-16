# == Schema Information
# Schema version: 1
#
# Table name: papers
#
#  id      :integer         not null, primary key
#  medline :integer
#  title   :string(255)
#  author  :string(255)
#  journal :string(255)
#

require 'test_helper'

class PaperTest < ActiveSupport::TestCase
  test "first cel-let-7 paper" do
    assert_equal('"An abundant class of tiny RNAs with probable regulatory roles in Caenorhabditis elegans"',  Mature.find_by_name('cel-let-7').papers.sort_by{|x| x.medline}.first.title)
  end
end
