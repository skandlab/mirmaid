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

class Paper < ActiveRecord::Base

  has_and_belongs_to_many :precursors
  
  def self.find_rest(id)
    return (self.find_by_medline(id.to_s) or self.find(id))
  end

  def species
    Paper.find(self.id,:include => {:precursors => :species}).precursors.map{|x| x.species}.flatten.uniq
  end

  def matures
    Paper.find(self.id,:include => {:precursors => :matures}).precursors.uniq.map{|x| x.matures}.flatten
  end
    
end
