# == Schema Information
#
# Table name: matures
#
#  id         :integer         not null, primary key
#  name       :string(40)      default(""), not null
#  accession  :string(20)      default(""), not null
#  evidence   :text
#  experiment :text
#  similarity :text
#  sequence   :string(255)
#

class Mature < ActiveRecord::Base
  has_and_belongs_to_many :precursors
  has_and_belongs_to_many :seed_families
#  has_many :m2d_disease_links
 
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
    self.name
  end
  
  def self.find_rest(id)
    if id.to_s.chomp =~ /\D/
      self.find_by_name(id)
    else
      self.find(id.to_i)
    end
  end

  # dynamic fuzzy name search
  def self.find_best_by_name(name,stack_depth=0)
    mats = []
    mats = self.find_all_by_name(name) if mats.empty?
    mats = self.find(:all,:conditions => ["name like ?",name]) if mats.empty?
    mats = self.find(:all,:conditions => ["name like ?","#{name}-?"]).reject{|m| m.name =~ /\*/} if mats.empty? # new variants (-1) or 5p/3p variants
    mats = self.find(:all,:conditions => ["name like ?","#{name}a"]).reject{|m| m.name =~ /\*/} if mats.empty? # new variants, "a" variant
    return mats if stack_depth==1 # avoid endless loop
    if mats.empty?  # go through precursors
      p = Precursor.find_best_by_name(name,1)
      mats = p.map{|x| x.matures}.flatten.uniq.reject{|m| m.name =~ /\*/} if !p.nil?
    end
    if mats.empty? #still no match, try removing "-\d" or "-\w"
      newname = name.match(/^(.+)-\w$/).to_a.last
      mats = self.find_best_by_name(newname) if !newname.nil?
    end
    if mats.empty? #still no match, try removing "[abcdefg]"
      newname = name.match(/^(.+)[abcdefg]$/).to_a.last
      mats = self.find_best_by_name(newname) if !newname.nil?
    end
    if mats.empty? #still no match, try removing "-[35]p"
      newname = name.match(/^(.+)-[35]p$/).to_a.last
      mats = self.find_best_by_name(newname) if !newname.nil?
    end
    if mats.empty? #still no match, try removing "*"
      newname = name.match(/^(.+)\*$/).to_a.last
      mats = self.find_best_by_name(newname) if !newname.nil?
    end
    return mats
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
