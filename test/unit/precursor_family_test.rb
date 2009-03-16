# == Schema Information
# Schema version: 1
#
# Table name: precursor_families
#
#  id          :integer         not null, primary key
#  accession   :string(15)      default(""), not null
#  name        :string(40)      default(""), not null
#  description :text
#

require 'test_helper'

class PrecursorFamilyTest < ActiveSupport::TestCase
  test "cel-let-7 precursor family size" do
    assert_operator(20, :<=, Precursor.find_by_name('cel-let-7').precursor_family.precursors.size)
  end

end
