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
    if id.to_s.chomp =~ /\D/
      self.find_by_name(id)
    else
      self.find(id.to_i)
    end
  end
  
end
