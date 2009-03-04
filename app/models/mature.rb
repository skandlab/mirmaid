class Mature < ActiveRecord::Base
  belongs_to :precursor
  
  def self.find_rest(id)
    if id.to_s.chomp =~ /\D/
      self.find_by_name(id)
    else
      self.find(id.to_i)
    end
  end

  def sequence(offset=0)
    # return sequence with offset i, default is mature sequence
    self.precursor.sequence[self.mature_from.to_i - 1 + offset .. self.mature_to.to_i - 1 + offset]
  end
  
  def papers
    self.precursor.papers
  end
  
end
