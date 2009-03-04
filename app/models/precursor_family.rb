class PrecursorFamily < ActiveRecord::Base
  has_many :precursors
  
  def self.find_rest(id)
    if id.to_s.chomp =~ /\D/
      self.find_by_name(id)
    else
      self.find(id.to_i)
    end
  end

  
end
