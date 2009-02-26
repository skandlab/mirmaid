# temporary model needed under initial mirbase->mibase import
class Precmature < ActiveRecord::Base
  belongs_to :precursor
  belongs_to :mature, :foreign_key => 'precmature_id'
end


