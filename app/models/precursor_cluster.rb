# == Schema Information
#
# Table name: precursor_clusters
#
#  id   :integer         not null, primary key
#  name :string(255)
#

class PrecursorCluster < ActiveRecord::Base
  
  has_and_belongs_to_many :precursors

  def self.find_rest(id)
    return (self.find_by_name(id.to_s) or self.find(id.to_i))
  end
  
end
