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

class PrecursorFamily < ActiveRecord::Base
  has_many :precursors
  
  def self.find_rest(id)
    return (self.find_by_name(id.to_s) or self.find(id.to_i))
  end
  
end
