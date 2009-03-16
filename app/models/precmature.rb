# == Schema Information
# Schema version: 1
#
# Table name: precmatures
#
#  precursor_id  :integer         default(0), not null
#  precmature_id :integer         default(0), not null
#

# temporary model needed under initial mirbase->mibase import
class Precmature < ActiveRecord::Base
  belongs_to :precursor
  belongs_to :mature, :foreign_key => 'precmature_id'
end


