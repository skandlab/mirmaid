require 'test_helper'

class PrecursorFamilyTest < ActiveSupport::TestCase
  test "cel-let-7 precursor family size" do
    assert_operator(20, :<=, Precursor.find_by_name('cel-let-7').precursor_family.precursors.size)
  end

end
