require 'net/http'
require 'uri'
require 'rubygems'
require 'progressbar'
require 'ftools'

mirbase_table_files = ['mirna_mature.txt',
                       'literature_references.txt',
                       'mirna_2_prefam.txt',
                       'mirna_chromosome_build.txt',
                       'mirna_context.txt',
                       'mirna_database_links.txt',
                       'mirna_literature_references.txt',
                       'mirna_prefam.txt',
                       'mirna_pre_mature.txt',
                       'mirna_species.txt',
                       'mirna.txt']

#############
### Tasks
#############

namespace :mirmaid do
  
  desc 'Load and configure MirMaid database for the database defined by RAILS_ENV.'
  task :load => [ 'mirmaid:load_msg',
                  'mirmaid:db:create',
                  'mirmaid:mirbase:fetch',
                  'mirmaid:mirbase:load',
                  'db:migrate',
                  'mirmaid:test:units',
                  'mirmaid:test:rest',
                  'mirmaid:ferret:index']
  
  desc 'Drop and load MirMaid database defined by RAILS_ENV.'
  task :reset => ['mirmaid:db:drop',
                  'mirmaid:load']
  
  task :load_msg do
    puts ""
    puts " >>> Loading MirMaid ..."
    puts " >>> Depending on your system and configuration, this process can take from 15 minutes to an hour"
    puts " >>> Your attention is only required if you use PostgreSQL - and only the first few minutes "
    puts ""
    sleep 10;
  end
  
  namespace :db do
    # Inspired by db:create, db:drop and db:reset
    
    desc ("Create database defined by RAILS_ENV")
    task :create => :environment do
      config = ActiveRecord::Base.configurations[RAILS_ENV]
      puts "\n >>> Creating database ..."
      #puts config.to_yaml
      case config['adapter']
      when 'mysql'
        #puts "Creating a mysql database named #{config['database']}"
        ActiveRecord::Base.establish_connection(config.merge({'database' => nil}))
        ActiveRecord::Base.connection.create_database(config['database'])
        ActiveRecord::Base.establish_connection(config)
      when 'sqlite3'
        #puts "Creating a sqlite3 database named #{config['database']}"
        Rake::Task['db:create'].invoke
      when 'postgresql'
        puts "psql will now prompt for your user password (you might need superuser permissions to create database)"
        system "createdb -h #{config['host']} #{config['database']} -E utf8" or raise('DB could not be created')
      end
    end
    
    desc ("Drop database defined by RAILS_ENV")
    task :drop => :environment do
      config = ActiveRecord::Base.configurations[RAILS_ENV]
      puts "\n >>> DATABASE WILL BE DROPPED IF YOU DONT TERMINATE ..."
      #puts config.to_yaml
      
      wait_secs = 5
      pbar = ProgressBar.new("CTRL-C ...", wait_secs)
      wait_secs.times {|i| pbar.inc; sleep 1; }
      pbar.finish
      
      begin
        case config['adapter']
        when 'mysql'
          ActiveRecord::Base.connection.drop_database config['database']
        when 'sqlite3'
          Rake::Task['db:drop'].invoke
        when 'postgresql'
          puts "psql will now prompt for your user password (you might need superuser permissions to drop database)"
          system "dropdb -h #{config['host']} #{config['database']}" or raise('DB could not be dropped')
        end
      rescue
        # nothing to drop
      end
    end
  
  end # :db
 
  namespace :ferret do
    
    desc "(re)build ferret indexes"
    task :index  => :environment do      
      
      #touch file config/ferret_enabled
      if !MIRMAID_CONFIG.ferret_enabled
        puts "Skipping Ferret indexing, not enabled in config/mirmaid_config.yml"
        exit(0)
      end
            
      puts "\n >>> (Re)building ferret indexes"
      puts " >>> this step can take some time ..."
      models = MIRMAID_CONFIG.ferret_models.map{|x| x.to_s.camelcase.constantize}
      models.each_with_index do |m,i|
        puts "Model #{i+1} of #{models.size}: " + m.name
        m.rebuild_index
      end
    end
  end
  
  namespace :mirbase do

    desc "Fetch miRBase data from local dir or ftp site, copy to tmp/mirbase-data/"
    task :fetch  => :environment do
      puts "\n >>> Fetching miRBase data ..."

      mirbase_data_dir = MIRMAID_CONFIG.mirbase_data_dir
      mirbase_version = MIRMAID_CONFIG.mirbase_version
      
      FileUtils.mkdir_p mirbase_data_dir
      
      if MIRMAID_CONFIG.mirbase_local_data
        # copy files from local dir
        puts " copying local miRBase data directory ..."
        FileUtils.cp_r(setup['mirbase']['local_data']+"/#{mirbase_version}/database_files/.",mirbase_data_dir)
        FileUtils.cp_r(setup['mirbase']['local_data']+"/#{mirbase_version}/README",mirbase_data_dir)
      elsif MIRMAID_CONFIG.mirbase_remote_data
        # wget remote files
        raise "'wget' command not found" if !system("wget --version > /dev/null") # check that wget is available
        puts " copying remote miRBase data ..."
        system("wget -q -nc -nv -P #{mirbase_data_dir} ftp://ftp.sanger.ac.uk/pub/mirbase/sequences/#{mirbase_version}/database_files/*") or raise $?
        system("wget -q -nc -nv -P #{mirbase_data_dir} ftp://ftp.sanger.ac.uk/pub/mirbase/sequences//#{mirbase_version}/README") or raise $?
      end

      # unzip if needed
      zipped_files = Dir.glob("#{mirbase_data_dir}/*.gz")
      raise "'gunzip' command not found" if zipped_files and !system("gunzip --version > /dev/null") # check that gunzip is available
      puts " unzipping data files ..." if zipped_files
      zipped_files.each{|zipped_file| system("gunzip -f #{zipped_file}") or raise $?}

      # delete files not needed
      Dir["#{mirbase_data_dir}*.txt"].each{|f| File.delete(f) if not mirbase_table_files.include?(File.basename(f))}

      # copy README file
      File.copy(mirbase_data_dir+"/README",RAILS_ROOT+"/public/MIRBASE_README")
      
    end

    desc "Load raw miRBase tables and data"
    task :load  => :environment do
      
      mirbase_data_dir = MIRMAID_CONFIG.mirbase_data_dir
      
      puts "\n >>> Loading miRBase data ..."

      db_config = ActiveRecord::Base.configurations[RAILS_ENV]
      adapter  = db_config['adapter']
      host     = db_config['host']
      database = db_config['database']
      username = db_config['username']
      password = db_config['password']

      puts db_config[RAILS_ENV].to_yaml

      # asume that mirbase data is unzipped in tmp/mirbase_data/
            
      # make initial schema changes
      # check that sed is available : "sed --version"
      raise "'sed' command not found" if !(`echo 'mirmaid' | sed s/i/o/`.chomp == "mormaid") # check that sed is available
      sed = "sed 's/`mature_from` varchar(4) default NULL,/`mature_from` int(4) default NULL,/'"
      sed += "| sed 's/`mature_to` varchar(4) default NULL,/`mature_to` int(4) default NULL,/'"
      sed += "| sed 's/`sequence` blob,/`sequence` longtext,/'"
      
      case adapter
      when "postgresql"
        puts "psql might prompt multiple times for the database password in your database.yml configuration: " + password
        puts "read more about how to avoid this: http://www.postgresql.org/docs/8.3/static/libpq-pgpass.html"
        sleep 5;
        psql = "psql -h #{host} -d #{database} -U #{username}"
        system("cat #{mirbase_data_dir}tables.sql | #{sed} | #{RAILS_ROOT}/script/mysql_to_postgres.rb | #{psql}") or
          raise("Error reading table definitions: " + $?)
        Dir["#{mirbase_data_dir}*.txt"].each do |f|
          table = (File.basename(f,".txt"))
          puts table
          system("cat #{f} | #{psql} -c \'copy #{table} from stdin\'") or raise ("Error loading miRBase data: " + $?)
        end
      when "sqlite3"
        system("cat #{mirbase_data_dir}tables.sql | #{sed} | #{RAILS_ROOT}/script/mysql_to_postgres.rb > #{mirbase_data_dir}/sqlite_tables.sql") or
          raise("Error reading table definitions: " + $?)
        system("sqlite3 -init #{mirbase_data_dir}/sqlite_tables.sql #{database} '.exit'") or raise("sqlite3 table definitions error: " + $?)
        sqlite_data_script = File.new("#{mirbase_data_dir}/sqlite_data.script","w")
        sqlite_data_script.puts ".separator '\t'"
        Dir["#{mirbase_data_dir}*.txt"].each do |f|
          table = (File.basename(f,".txt"))
          sqlite_data_script.puts ".import \'#{f}\' #{table}"
        end
        sqlite_data_script.close
        system("sqlite3 #{database} '.read #{mirbase_data_dir}/sqlite_data.script'") or raise("sqlite3 data error: " + $?)
      when "mysql"
        puts "mysql will prompt for your password twice:"
        mysql = "mysql -u #{username} -p #{database}"
        system("cat #{mirbase_data_dir}tables.sql | #{sed} | #{mysql}") or raise ('Error loading table definitions: ' + $?)
        system("mysqlimport -u #{username} -p #{database} -L #{mirbase_data_dir}*.txt") or raise('Error loading miRbase data : ' + $?)
      else
        raise "MirMaid unsupported database: #{adapter}"
      end

    end
  end # :mirbase
end # :mirmaid
