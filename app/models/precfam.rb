# temporary model needed under initial mirbase->mibase import
class Precfam < ActiveRecord::Base
  belongs_to :precursor_family
  belongs_to :precursor, :foreign_key => 'precfam_id'
end


