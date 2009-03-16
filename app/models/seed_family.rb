# == Schema Information
# Schema version: 1
#
# Table name: seed_families
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  sequence   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class SeedFamily < ActiveRecord::Base

  has_and_belongs_to_many :matures

  def self.find_rest(id)
    if id.to_s.chomp =~ /\D/
      #id = id.upcase.tr('T','U')
      self.find_by_name(id)
    else
      self.find(id.to_i)
    end
  end

  
end
