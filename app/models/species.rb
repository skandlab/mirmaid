class Species < ActiveRecord::Base
  has_many :precursors

  def self.find_rest(id)
    if id.to_s.chomp =~ /\D/
      self.find_by_abbreviation(id)
    else
      self.find(id)
    end
  end

  def papers
    Precursor.find_all_by_species_id(self.id,:include => :papers).map{|x| x.papers}.flatten.uniq
  end
  
  def matures
    Precursor.find_all_by_species_id(self.id,:include => :matures).map{|x| x.matures}.flatten.uniq
  end

  
end
