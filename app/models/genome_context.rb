# == Schema Information
# Schema version: 1
#
# Table name: genome_contexts
#
#  precursor_id      :integer         default(0), not null
#  transcript_id     :string(50)
#  overlap_sense     :string(2)
#  overlap_type      :string(20)
#  number            :integer
#  transcript_source :string(50)
#  transcript_name   :string(50)
#

class GenomeContext < ActiveRecord::Base
  
  belongs_to :precursor
  
end
