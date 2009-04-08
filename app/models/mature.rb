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
  belongs_to :precursor
  has_and_belongs_to_many :seed_families
 
  acts_as_ferret :fields => {
    :name => {:store => :yes, :boost => 4},
    :name_for_sort => {:index => :untokenized},
    :sequence => {:store => :yes},
    :evidence => {:store => :yes},
    :experiment => {:store => :yes}
  }, :store_class_name => 'true'

  def name_for_sort
    self.name
  end
  
  def self.find_rest(id)
    if id.to_s.chomp =~ /\D/
      self.find_by_name(id)
    else
      self.find(id.to_i)
    end
  end

  def get_sequence(offset=0)
    # return sequence with offset i, default is mature sequence
    self.precursor.sequence[self.mature_from - 1 + offset .. self.mature_to - 1 + offset]
  end
  
  def papers
    self.precursor.papers
  end
  
end
