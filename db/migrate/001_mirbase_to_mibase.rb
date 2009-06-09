require 'progressbar'
require 'pp'

class MirbaseToMibase < ActiveRecord::Migration
  
  def self.up
    
    puts "\n >>> Setting up database"
    
    # force ferret indexing off during this process
    ferret_status = MIRMAID_CONFIG.ferret_enabled
    MIRMAID_CONFIG.ferret_enabled = false
    
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
    add_column :matures, :sequence, :string

    # matures_precursors
    rename_table :mirna_pre_mature, :matures_precursors
    rename_column :matures_precursors, :auto_mirna, :precursor_id
    rename_column :matures_precursors, :auto_mature, :mature_id
                
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
    
    # seed families

    create_table :seed_families do |t|
      t.column "name", :string
      t.column "sequence", :string
    end

    create_table(:matures_seed_families,:id=>false) do |t|
      t.column "mature_id", :integer
      t.column "seed_family_id", :integer
    end
    
    # Indexes
    add_index :species, :id, :unique => true
    add_index :species, :abbreviation, :unique => true
    
    add_index :precursors, :id, :unique => true
    add_index :precursors, :name, :unique => true
    add_index :precursors, :species_id
    
    add_index :matures, :id, :unique => true
    
    add_index :precursor_families, :id, :unique => true

    add_index :genome_contexts, :precursor_id

    add_index :genome_positions, :precursor_id
    add_index :genome_positions, :xsome

    add_index :papers, :id, :unique => true
    # medline is not unique of some reason
    add_index :papers, :medline #, :unique => true 

    add_index :precursor_external_synonyms, :precursor_id

    add_index :papers_precursors, :precursor_id
    add_index :papers_precursors, :paper_id

    add_index :seed_families, :id, :unique => true
    add_index :seed_families, :name, :unique => true
       
    puts "##### precursor <-> precursor families"
    # precursor > precursor_families
    # we take the mirbase precursor<->precursor_family many-many mapping and
    # makes it many-one.
    # As of miRBase 12.0, there are no precursors with multiple
    # families - meaning that precursor_id in precfams is unique
    
    ActiveRecord::Base::connection().update("update precursors \
                                  set precursor_family_id = (select max(auto_prefam) from mirna_2_prefam where precursors.id = auto_mirna) \ 
                                  where exists (select 1 from mirna_2_prefam where precursors.id = auto_mirna)")

    add_index :precursors, :precursor_family_id
    
    puts "##### matures <-> precursor"
    # precursor <-> matures,
    # relationship is many<->many, but miRBase has duplicate matures
    # instead of using the relationship
    # We remove duplicate matures,i.e. hsa-miR-124 should map to precursor
    # hsa-mir-124-1, -2 and -3
    # Furthermore, we store the sequence of the mature and removes
    # start/stop coordinates (which should have been part of the join table)
    
    #pbar = ProgressBar.new("progress",Species.count)
    #ActiveRecord::Base.transaction do # speed up
    #  Species.find_each(:batch_size => 10) do |sp|
    #    sp.matures.group_by{|x| x.name}.to_a.each do |name,mats|
    pbar = ProgressBar.new("progress", Mature.count(:name,:distinct => 1))
    ActiveRecord::Base.transaction do # speed up
      Mature.find(:all).group_by{|x| x.name}.to_a.each do |name,mats|
        pbar.inc
        mat = mats.first
        mats[1..-1].each do |m| # only keep first mature
          mat.precursors += m.precursors # point precursors to mature that we keep
          m.destroy
        end
        mat.experiment = "" if mat.experiment == "\N"
        mat.precursors.uniq!
        mat.sequence = mat.precursor.sequence[mat.mature_from - 1 .. mat.mature_to - 1]
        mat.name = mat.name.gsub('.','_') # problems with dots in
        # id's, i.e. mmu-miR-1982.1, hard to fix in routings
        mat.save
      end
    end
    pbar.finish
    
    remove_column :matures, :mature_from # redundant (and wrong)
    remove_column :matures, :mature_to

    add_index :matures, :name, :unique => true
    add_index :matures_precursors, :precursor_id
    add_index :matures_precursors, :mature_id
    
    # seed families
    # and store mature sequence
    puts "##### seed families"
    
    pbar = ProgressBar.new("progress", Mature.count)
    ActiveRecord::Base.transaction do # speed up
      Species.find_each(:batch_size => 10) do |sp|
        sp.matures.each do |mat|
          [1..7,1..6,2..7].each do |srange|
            seq = mat.sequence[srange]
            seedname = "#{sp.abbreviation}-#{seq}"
            sf = SeedFamily.find_or_create_by_name(:name=>seedname,:sequence=>seq)
            sf.matures << mat
            sf.save
          end
          pbar.inc
        end
      end
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
    ActiveRecord::Base.transaction do # speed up
      Precursor.find_each(:include=>:genome_positions) do |p|
        pbar.inc
        [1,10].each do |kb|
          pc = PrecursorCluster.new(:name=>"#{p.name}-#{kb}kb")
          pc.precursors = p.nearby_precursors(kb*1000) + [p]
          pc.save
        end
      end
    end
    pbar.finish
    
    add_index :precursor_clusters, :id, :unique => true
    add_index :precursor_clusters, :name, :unique => true
    add_index :precursor_clusters_precursors, :precursor_id
    add_index :precursor_clusters_precursors, :precursor_cluster_id
    
    # set original ferret status
    MIRMAID_CONFIG.ferret_enabled = ferret_status
    
  end
    
  def self.down
  end
  
end
