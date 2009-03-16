class Precursor < ActiveRecord::Base
  belongs_to :species
  has_many :matures
  belongs_to :precursor_family
  has_many :genome_positions #since there are some that maps perfectly to more than one postion
  has_many :genome_contexts
  has_and_belongs_to_many :precursor_clusters
  has_and_belongs_to_many :papers
  has_many :precursor_external_synonyms

  def self.find_rest(id)
    if id.to_s.chomp =~ /\D/
      self.find_by_name(id)
    else
      self.find(id.to_i)
    end
  end

  def nearby_precursors(dist=10000)
    posa = self.genome_positions
    neighbours = []
    
    posa.each do |pos|
      distrange = pos.contig_start - dist .. pos.contig_start+dist
      posn = GenomePosition.find(:all,:conditions => {:xsome => pos.xsome,:contig_start => distrange},:include=>['precursor'])
      neighbours += posn.map{|x| x.precursor}.select{|x| x.species_id == self.species_id}
    end

    return neighbours.uniq-[self]
    
  end
  
end
