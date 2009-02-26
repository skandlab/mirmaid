class Mature < ActiveRecord::Base
  belongs_to :precursor

  def sequence(offset=0)
    # return sequence with offset i, default is mature sequence
    self.precursor.sequence[self.mature_from.to_i - 1 + offset .. self.mature_to.to_i - 1 + offset]
  end
 
end
