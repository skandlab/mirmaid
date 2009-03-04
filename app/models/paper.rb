class Paper < ActiveRecord::Base

  has_and_belongs_to_many :precursors
  
  def self.find_rest(id)
    if id.to_s.chomp =~ /^pmid/
      self.find_by_medline(id.scan(/^pmid:(\d+)/).first)
    else
      self.find(id)
    end
  end

  def species
    Paper.find(self.id,:include => {:precursors => :species}).precursors.map{|x| x.species}.flatten.uniq
  end

  def matures
    Paper.find(self.id,:include => {:precursors => :matures}).precursors.uniq.map{|x| x.matures}.flatten
  end
    
end
