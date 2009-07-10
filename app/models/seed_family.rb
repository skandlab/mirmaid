# == Schema Information
#
# Table name: seed_families
#
#  id       :integer         not null, primary key
#  name     :string(255)
#  sequence :string(255)
#

class SeedFamily < ActiveRecord::Base

  has_and_belongs_to_many :matures

  def self.find_rest(id)
    return (self.find_by_name(id.to_s) or self.find(id))
  end

  def to_param
    self.name
  end
 
end
