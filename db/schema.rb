# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "dead_mirna", :id => false, :force => true do |t|
    t.string "mirna_acc",   :limit => 9,   :default => "", :null => false
    t.string "mirna_id",    :limit => 40,  :default => "", :null => false
    t.string "previous_id", :limit => 100
    t.string "forward_to",  :limit => 20
    t.text   "comment"
  end

  create_table "genome_contexts", :id => false, :force => true do |t|
    t.integer "precursor_id",                    :default => 0, :null => false
    t.string  "transcript_id",     :limit => 50
    t.string  "overlap_sense",     :limit => 2
    t.string  "overlap_type",      :limit => 20
    t.integer "number"
    t.string  "transcript_source", :limit => 50
    t.string  "transcript_name",   :limit => 50
  end

  add_index "genome_contexts", ["precursor_id"], :name => "index_genome_contexts_on_precursor_id"

  create_table "genome_positions", :id => false, :force => true do |t|
    t.integer "precursor_id",               :default => 0, :null => false
    t.string  "xsome",        :limit => 20
    t.integer "contig_start", :limit => 8
    t.integer "contig_end",   :limit => 8
    t.string  "strand",       :limit => 2
  end

  add_index "genome_positions", ["precursor_id"], :name => "index_genome_positions_on_precursor_id"

  create_table "matures", :force => true do |t|
    t.string  "name",         :limit => 40, :default => "", :null => false
    t.string  "accession",    :limit => 20, :default => "", :null => false
    t.integer "mature_from"
    t.integer "mature_to"
    t.text    "evidence"
    t.text    "experiment"
    t.text    "similarity"
    t.integer "precursor_id"
  end

  add_index "matures", ["id"], :name => "index_matures_on_id", :unique => true
  add_index "matures", ["precursor_id"], :name => "index_matures_on_precursor_id"

  create_table "mirna_target_links", :id => false, :force => true do |t|
    t.integer "auto_mature",  :default => 0, :null => false
    t.integer "auto_db",      :default => 0, :null => false
    t.string  "display_name",                :null => false
    t.string  "field1"
    t.string  "field2"
  end

  create_table "mirna_target_url", :id => false, :force => true do |t|
    t.integer "auto_db",      :null => false
    t.string  "display_name", :null => false
    t.string  "url",          :null => false
  end

  create_table "papers", :force => true do |t|
    t.integer "medline"
    t.string  "title"
    t.string  "author"
    t.string  "journal"
  end

  add_index "papers", ["id"], :name => "index_papers_on_id", :unique => true

  create_table "papers_precursors", :id => false, :force => true do |t|
    t.integer "precursor_id",              :default => 0, :null => false
    t.integer "paper_id",                  :default => 0, :null => false
    t.text    "comment"
    t.integer "order_added",  :limit => 2
  end

  add_index "papers_precursors", ["paper_id", "precursor_id"], :name => "index_papers_precursors_on_precursor_id_and_paper_id"

  create_table "precfams", :id => false, :force => true do |t|
    t.integer "precfam_id",          :default => 0, :null => false
    t.integer "precursor_family_id", :default => 0, :null => false
  end

  create_table "precmatures", :id => false, :force => true do |t|
    t.integer "precursor_id",  :default => 0, :null => false
    t.integer "precmature_id", :default => 0, :null => false
  end

  create_table "precursor_external_synonyms", :id => false, :force => true do |t|
    t.integer "precursor_id", :default => 0, :null => false
    t.string  "db_id",                       :null => false
    t.string  "comment"
    t.string  "db_link",                     :null => false
    t.string  "db_secondary"
    t.string  "other_params"
  end

  add_index "precursor_external_synonyms", ["precursor_id"], :name => "index_precursor_external_synonyms_on_precursor_id"

  create_table "precursor_families", :force => true do |t|
    t.string "accession",   :limit => 15, :default => "", :null => false
    t.string "name",        :limit => 40, :default => "", :null => false
    t.text   "description"
  end

  add_index "precursor_families", ["id"], :name => "index_precursor_families_on_id", :unique => true

  create_table "precursors", :force => true do |t|
    t.string  "accession",           :limit => 9,   :default => "", :null => false
    t.string  "name",                :limit => 40,  :default => "", :null => false
    t.string  "description",         :limit => 100
    t.binary  "sequence"
    t.text    "comment"
    t.integer "species_id",                         :default => 0,  :null => false
    t.integer "precursor_family_id"
  end

  add_index "precursors", ["id"], :name => "index_precursors_on_id", :unique => true
  add_index "precursors", ["precursor_family_id"], :name => "index_precursors_on_precursor_family_id"

  create_table "species", :force => true do |t|
    t.string "abbreviation",    :limit => 10
    t.string "division",        :limit => 10
    t.string "name",            :limit => 100
    t.string "taxonomy",        :limit => 200
    t.string "genome_assembly", :limit => 15
    t.string "ensembl_db",      :limit => 50
  end

  add_index "species", ["id"], :name => "index_species_on_id", :unique => true

end
