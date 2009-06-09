# == Schema Information
# Schema version: 1
#
# Table name: matures
#
#  id           :integer         not null, primary key
#  name         :string(40)      default(""), not null
#  accession    :string(20)      default(""), not null
#  mature_from  :integer
#  mature_to    :integer
#  evidence     :text
#  experiment   :text
#  similarity   :text
#  precursor_id :integer
#

class Mature < ActiveRecord::Base
  has_and_belongs_to_many :precursors
  has_and_belongs_to_many :seed_families
 
  acts_as_ferret :fields => {
    :name => {:store => :yes, :boost => 4},
    :name_for_sort => {:index => :untokenized},
    :sequence => {:store => :yes},
    :evidence => {:store => :yes},
    :experiment => {:store => :yes}
  }, :store_class_name => 'true'
 
  def name_for_sort
    self.name.downcase
  end
  
  def self.ferret_enabled?
    MIRMAID_CONFIG.ferret_enabled
  end
  
  def to_param
    name
  end
  
  def self.find_rest(id)
    if id.to_s.chomp =~ /\D/
      self.find_by_name(id)
    else
      self.find(id.to_i)
    end
  end
 
  def papers
    self.precursor.papers
  end
  
  def precursor
    self.precursors.first # pick first if there are multiple precursors
  end   
  
  def seed_family_members
    #return hash: seed seq => [matures]
    members = Hash.new()
    self.seed_families.each do |sf|
      members[sf.sequence] = sf.matures - [self]
    end
    return members
  end
  
  def seed_family_members_other_species
    #only use 7mer seed family
    #return hash: seed seq => [matures]
    seed7m = self.seed_families.select{|x| x.sequence.size == 7}.first.sequence
    return Mature.find(:all,:conditions => "seed_families.sequence='#{seed7m}'",:include=>[:seed_families,:precursors]).select{|x| x.precursor.species_id != self.precursor.species_id}
  end
  
end
