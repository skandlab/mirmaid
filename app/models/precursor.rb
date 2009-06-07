# == Schema Information
# Schema version: 1
#
# Table name: precursors
#
#  id                  :integer         not null, primary key
#  accession           :string(9)       default(""), not null
#  name                :string(40)      default(""), not null
#  description         :string(100)
#  sequence            :text
#  comment             :text
#  species_id          :integer         default(0), not null
#  precursor_family_id :integer
#

class Precursor < ActiveRecord::Base
  belongs_to :species
  has_and_belongs_to_many :matures
  belongs_to :precursor_family
  has_many :genome_positions #since there are some that maps perfectly to more than one postion
  has_many :genome_contexts
  has_and_belongs_to_many :precursor_clusters
  has_and_belongs_to_many :papers
  has_many :precursor_external_synonyms

  acts_as_ferret :fields => {
    :name => {:store => :yes, :boost => 4, :index => :untokenized},
    :name_for_sort => {:index => :untokenized},
    :comment => {:store => :yes},
    :mature_names => {:store => :yes, :boost => 2},
    :xsome => {:store => :yes},
    :contig_start => {:store => :yes}
  }, :store_class_name => 'true'

  def name_for_sort
    self.name
  end

  def self.ferret_enabled?
    MIRMAID_CONFIG.ferret_enabled
  end
   
  def self.find_rest(id)
    if id.to_s.chomp =~ /\D/
      self.find_by_name(id)
    else
      self.find(id.to_i)
    end
  end
  
  def mature_names
    self.matures.map{|x| x.name}.join(', ')
  end

  def xsome
    p = self.genome_positions.first
    p.nil? ? "NA" : p.xsome
  end

  def contig_start
    p = self.genome_positions.first
    p.nil? ? "NA" : p.contig_start
  end

  def genome_coords
    p = self.genome_positions.first
    p.nil? ? "NA" : p.xsome + p.strand.to_s.strip + ":" + p.contig_start.to_s + "-" + p.contig_end.to_s
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
