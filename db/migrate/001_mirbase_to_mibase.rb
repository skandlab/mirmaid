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
    add_column :genome_positions, :id, :primary_key
    
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

    puts "##### precursor <-> precursor families"
    pbar = ProgressBar.new("progress",Precfam.count)
    Precfam.find(:all).each do |pf|
      p = pf.precursor
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

    puts "##### matures <-> precursor"
    pbar = ProgressBar.new("progress",Precmature.count)
    Precmature.find(:all).each do |pm|
      m = pm.mature
      m.precursor = pm.precursor
      m.save
      pbar.inc
    end
    pbar.finish

    # Indexes
    puts "##### indexing ..."
    
    add_index :species, :id, :unique => true
    add_index :species, :abbreviation, :unique => true
    
    add_index :precursors, :id, :unique => true
    add_index :precursors, :name, :unique => true
    add_index :precursors, :species_id
    add_index :precursors, :precursor_family_id

    add_index :matures, :id, :unique => true
    add_index :matures, :name
    add_index :matures, :precursor_id
    
    add_index :precursor_families, :id, :unique => true

    add_index :genome_contexts, :precursor_id

    add_index :genome_positions, :precursor_id
    add_index :genome_positions, :xsome

    add_index :papers, :id, :unique => true
    add_index :papers, :medline, :unique => true

    add_index :precursor_external_synonyms, :precursor_id

    add_index :papers_precursors, :precursor_id
    add_index :papers_precursors, :paper_id
    
    # seed families
    puts "##### seed families"
    create_table :seed_families do |t|
      t.column "name", :string
      t.column "sequence", :string
    end

    create_table(:matures_seed_families,:id=>false) do |t|
      t.column "mature_id", :integer
      t.column "seed_family_id", :integer
    end
    
    add_index :seed_families, :id, :unique => true
    add_index :seed_families, :name, :unique => true
    
    pbar = ProgressBar.new("progress",Species.count)    
    Species.find(:all).each do |sp|
      sp.matures.each do |mat|
        [1..7,1..6,2..7].each do |srange|
          seq = mat.sequence[srange]
          seedname = "#{sp.abbreviation}-#{seq}"
          sf = SeedFamily.find_or_create_by_name(:name=>seedname,:sequence=>seq)
          sf.matures << mat
          sf.save
        end
      end
      pbar.inc
    end
    pbar.finish
    
    add_index :matures_seed_families, :mature_id
    add_index :matures_seed_families, :seed_family_id       
    
    #return
    # precursor clusters
    puts "##### precursor clusters"
    create_table :precursor_clusters do |t|
      t.column "name", :string
    end
    
    create_table(:precursor_clusters_precursors,:id=>false) do |t|
      t.column "precursor_id", :integer
      t.column "precursor_cluster_id", :integer
    end

    pbar = ProgressBar.new("progress",Precursor.count)    
    Precursor.find(:all,:include=>[:genome_positions]).each do |p|
      pbar.inc
      [1,10,100].each do |kb|
        dist = 1*1000
        pc = PrecursorCluster.new(:name=>"#{p.name}-#{kb}kb")
        pc.precursors = p.nearby_precursors(dist) + [p]
        pc.save
      end
    end
    pbar.finish
    
    add_index :precursor_clusters, :id, :unique => true
    add_index :precursor_clusters, :name, :unique => true
    add_index :precursor_clusters_precursors, :precursor_id
    add_index :precursor_clusters_precursors, :precursor_cluster_id
   
  end
    
  def self.down
  end
  
end
