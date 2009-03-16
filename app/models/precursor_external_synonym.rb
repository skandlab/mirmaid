# == Schema Information
# Schema version: 1
#
# Table name: precursor_external_synonyms
#
#  precursor_id :integer         default(0), not null
#  db_id        :string(255)     not null
#  comment      :string(255)
#  db_link      :string(255)     not null
#  db_secondary :string(255)
#  other_params :string(255)
#

class PrecursorExternalSynonym < ActiveRecord::Base
  
  belongs_to :precursor
  
end
