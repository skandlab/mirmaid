require 'progressbar'
require 'pp'

class MirbaseToMibase < ActiveRecord::Migration
  
  def self.up

    # Divided into sections for each table

    # species ok

    rename_table :mirna_species, :species
    rename_column :species, :auto_id, :id
    rename_column :species, :organism, :abbreviation # shortname
    
    # precursors ok

    rename_table :mirna, :precursors
    rename_column :precursors, :auto_mirna, :id
    rename_column :precursors, :auto_species, :species_id
    rename_column :precursors, :mirna_acc, :accession
    rename_column :precursors, :mirna_id, :name
    add_column :precursors, :precursor_family_id, :integer
    
    # matures ok

    rename_table :mirna_mature, :matures
    rename_column :matures, :auto_mature, :id
    rename_column :matures, :mature_name, :name
    rename_column :matures, :mature_acc, :accession
    add_column :matures, :precursor_id, :integer
                
    # precursor_families ok
      
    rename_table :mirna_prefam, :precursor_families
    rename_column :precursor_families, :auto_prefam, :id
    rename_column :precursor_families, :prefam_id, :name
    rename_column :precursor_families, :prefam_acc, :accession
    
    # genome_contexts ok
    
    rename_table :mirna_context, :genome_contexts
    rename_column :genome_contexts, :auto_mirna, :precursor_id
    
    # genome_positions ok

    rename_table :mirna_chromosome_build, :genome_positions
    rename_column :genome_positions, :auto_mirna, :precursor_id
    
    # papers ok

    rename_table :literature_references, :papers
    rename_column :papers, :auto_lit, :id
    
    # precursor_external_synonyms ok
    
    rename_table :mirna_database_links, :precursor_external_synonyms
    rename_column :precursor_external_synonyms, :auto_mirna, :precursor_id
  
    # precursors <-> papers

    rename_table :mirna_literature_references, :papers_precursors
    rename_column :papers_precursors, :auto_mirna, :precursor_id
    rename_column :papers_precursors, :auto_lit, :paper_id

    # precursor > precursor_families
    # we take the mirbase precursor<->precursor_family many-many mapping and
    # makes it many-one.
    # As of miRBase 12.0, there are no precursors with multiple
    # families - meaning that precursor_id in precfams is unique
    
    rename_table :mirna_2_prefam, :precfams
    rename_column :precfams, :auto_mirna, :precfam_id
    rename_column :precfams, :auto_prefam, :precursor_family_id

    puts ">> precursor <-> precursor families"
    pbar = ProgressBar.new("remapping",Precfam.count)
    Precfam.find(:all).each do |pf|
      p = pf.precursor
      #pp pf
      #pp p
      p.precursor_family = pf.precursor_family
      p.save
      pbar.inc
    end
    pbar.finish
    
    # precursor < matures
    # we take the mirbase precursor<->mature many-many mapping and
    # makes it one-many.
    # As of miRBase 12.0, there are no matures with multiple
    # precursors - meaning that mature_id in :precmatures is unique
    rename_table :mirna_pre_mature, :precmatures
    rename_column :precmatures, :auto_mirna, :precursor_id
    rename_column :precmatures, :auto_mature, :precmature_id

    puts ">> matures <-> precursor"
    pbar = ProgressBar.new("remapping",Precmature.count)
    Precmature.find(:all).each do |pm|
      m = pm.mature
      m.precursor = pm.precursor
      m.save
      pbar.inc
    end
    pbar.finish

    # Indexes
    puts "indexing ..."
    
    add_index :species, :id, :unique => true
    add_index :species, :abbreviation, :unique => true
    
    add_index :precursors, :id, :unique => true
    add_index :precursors, :name, :unique => true
    add_index :precursors, :precursor_family_id

    add_index :matures, :id, :unique => true
    add_index :matures, :name
    add_index :matures, :precursor_id
    
    add_index :precursor_families, :id, :unique => true

    add_index :genome_contexts, :precursor_id

    add_index :genome_positions, :precursor_id

    add_index :papers, :id, :unique => true
    add_index :papers, :medline, :unique => true

    add_index :precursor_external_synonyms, :precursor_id

    add_index :papers_precursors, [:precursor_id,:paper_id]
    
  end

  def self.down
  end
  
end
