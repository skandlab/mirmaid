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
  
  def seed_families
    Precursor.find_all_by_species_id(self.id,:include => {:matures => :seed_families}).map{|x| x.matures}.flatten.uniq.map{|x| x.seed_families}.flatten
  end
  
  def precursor_clusters
    Precursor.find_all_by_species_id(self.id,:include => :precursor_clusters).map{|x| x.precursor_clusters}.flatten
  end
  
end
