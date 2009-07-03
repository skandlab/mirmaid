# == Schema Information
# Schema version: 1
#
# Table name: species
#
#  id              :integer(8)      not null, primary key
#  abbreviation    :string(10)
#  division        :string(10)
#  name            :string(100)
#  taxonomy        :string(200)
#  genome_assembly :string(15)
#  ensembl_db      :string(50)
#

class Species < ActiveRecord::Base
  has_many :precursors
  
  acts_as_ferret :fields => {
    :abbreviation => {:store => :yes},
    :name => {:store => :yes},
    :name_for_sort => {:store => :yes,:index => :untokenized},
    :taxonomy => {:store => :yes},
    :taxonomy_for_sort => {:store => :yes}
  }, :store_class_name => 'true'

  def name_for_sort
    self.name.downcase
  end
  
  def self.ferret_enabled?
    MIRMAID_CONFIG.ferret_enabled
  end
  
  def taxonomy_for_sort
    self.taxonomy
  end
  
  def to_param
    abbreviation
  end
  
  def self.find_rest(id)
    return (self.find_by_abbreviation(id.to_s) or self.find(id))
  end
    
  def papers
    Precursor.find_all_by_species_id(self.id,:include => :papers).map{|x| x.papers}.flatten.uniq
  end
  
  def matures
    Precursor.find_all_by_species_id(self.id,:include => :matures).map{|x| x.matures}.flatten.uniq
  end
  
  def seed_families
    Precursor.find_all_by_species_id(self.id,:include => {:matures => :seed_families}).map{|x| x.matures}.flatten.uniq.map{|x| x.seed_families}.flatten
  end
  
  def precursor_clusters
    Precursor.find_all_by_species_id(self.id,:include => :precursor_clusters).map{|x| x.precursor_clusters}.flatten
  end

  def precursors_count
    Precursor.count(:conditions => "species_id = #{self.id}")
  end
  
  def matures_count
    Mature.count(:conditions => "species_id = #{self.id}", :include => {:precursors => :species})
  end
  
end
