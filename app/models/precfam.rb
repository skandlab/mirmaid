# == Schema Information
# Schema version: 1
#
# Table name: precfams
#
#  precfam_id          :integer         default(0), not null
#  precursor_family_id :integer         default(0), not null
#

# temporary model needed under initial mirbase->mibase import
class Precfam < ActiveRecord::Base
  belongs_to :precursor_family
  belongs_to :precursor, :foreign_key => 'precfam_id'
end


