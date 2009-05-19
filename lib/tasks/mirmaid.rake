require 'net/http'
require 'uri'
require 'rubygems'
require 'progressbar'
require 'config/environment'
require 'ftools'

#Global settings
setup = YAML.load_file(RAILS_ROOT + "/setup.yml")
mirbase_version = setup['mirbase']['version'] || "CURRENT"
mirbase_data = RAILS_ROOT + "/tmp/mirbase_data/"
# the database files have to be unzipped!
# local_data   = "/data1/genome_seq/mirbase/mirror"
# mirbase_data = "#{mirbase_dir}/#{mirbase_version}/database_files/"

#############
### Tasks
#############

namespace :mirmaid do

  namespace :db do

    # Inspired by db:create, db:drop and db:reset :
    
    desc ("Create database defined by RAILS_ENV")
    task :create => :environment do
      config = ActiveRecord::Base.configurations[RAILS_ENV]
      puts config.to_yaml
      case config['adapter']
      when 'mysql'
        puts "Creating a mysql database named #{config['database']}"
        ActiveRecord::Base.establish_connection(config.merge({'database' => nil}))
        ActiveRecord::Base.connection.create_database(config['database'])
        ActiveRecord::Base.establish_connection(config)
      when 'postgresql'
        system "createdb -h #{config['host']} #{config['database']} -E utf8" or raise('DB could not be created')
      end
    end
    
    desc ("Drop database defined by RAILS_ENV")
    task :drop => :environment do
      config = ActiveRecord::Base.configurations[RAILS_ENV]
      puts "DATABASE WILL BE DROPPED IF YOU DONT TERMINATE ..."
      puts config.to_yaml
      
      waitsecs = 1
      pbar = ProgressBar.new("CTRL-C ...", waitsecs)
      (1..waitsecs).each {|x| pbar.inc; sleep 1  }
      pbar.finish

      case config['adapter']
      when 'mysql'
        ActiveRecord::Base.connection.drop_database config['database']
      when 'postgresql'
        system "dropdb -h #{config['host']} #{config['database']}" or raise('DB could not be dropped')
      end
    end
    
    desc 'Create, migrate, load and test data for the database defined by RAILS_ENV.'
    task :load => [ 'mirmaid:db:create',
                    'mirmaid:load:fetch_mirbase',
                    'mirmaid:load:mirbase',
                    'db:migrate',
                    'mirmaid:ferret:index',
                    'mirmaid:test:units']

    
    desc 'Drop and load the database defined by RAILS_ENV.'
    task :reset => ['mirmaid:db:drop',
                    'mirmaid:db:load']

  end # :db
  
  # how to convert from mirbase mysql to sqlite ...
  # task to wget mirbase ...
  
  namespace :little do

    desc 'Little Mirmaid: Create, migrate, load and test data for the database defined by RAILS_ENV.'
    task :load => [ 'mirmaid:db:create',
                    'mirmaid:load:fetch_mirbase',
                    'mirmaid:load:mirbase',
                    'db:migrate',
                    'mirmaid:test:units']

    
    desc 'Little Mirmaid: Drop and load the database defined by RAILS_ENV.'
    task :reset => ['mirmaid:db:drop',
                    'mirmaid:little:load']
    
  end # :little
  
  namespace :ferret do
    
    desc "[1] (re)builds ferret indexes"
    task :index  => :environment do

      puts "(Re)building ferret indexes"
      puts "this step can take some time, come back in an hour ..."
      models = [Species,Precursor,Mature]
      models.each_with_index do |m,i|
        puts "Model #{i+1} of #{models.size}: " + m.name
        m.rebuild_index
      end
    end
  end
  
  namespace :load do

    desc "[1] fetch miRBase data from local dir or ftp site, copy to tmp/mirbase-data/"
    task :fetch_mirbase  => :environment do
      puts "fetching miRBase data ..."
      
      FileUtils.mkdir_p mirbase_data
      
      if setup['mirbase']['local_data']
        # copy files from local dir
        puts "copying local miRBase data directory ..."
        FileUtils.cp_r(setup['mirbase']['local_data']+"/#{mirbase_version}/database_files/.",mirbase_data)
        FileUtils.cp_r(setup['mirbase']['local_data']+"/#{mirbase_version}/README",mirbase_data)
      elsif setup['mirbase']['remote_data']
        # wget remote files
        raise "'wget' command not found" if !system("wget --version > /dev/null") # check that wget is available
        puts "copying remote miRBase data ..."
        system("wget -nc -nv -P #{mirbase_data} ftp://ftp.sanger.ac.uk/pub/mirbase/sequences/#{mirbase_version}/database_files/*") or raise $?
        system("wget -nc -nv -P #{mirbase_data} ftp://ftp.sanger.ac.uk/pub/mirbase/sequences//#{mirbase_version}/README") or raise $?
      end

      # unzip if needed
      zipped_files = Dir.glob("#{mirbase_data}/*.gz")
      raise "'gunzip' command not found" if zipped_files and !system("gunzip --version > /dev/null") # check that gunzip is available
      puts "unzipping data files ..." if zipped_files
      zipped_files.each{|zipped_file| system("gunzip -f #{zipped_file}") or raise $?}
      
      File.copy(mirbase_data+"/README",RAILS_ROOT+"/public/MIRBASE_README")
      
    end

    desc "[2] load raw miRBase tables and data"
    task :mirbase  => :environment do

      puts "Loading miRBase ..."

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
      raise "'sed' command not found" if !system("sed --version > /dev/null") # check that wget is available
      sed = "sed 's/`mature_from` varchar(4) default NULL,/`mature_from` int(4) default NULL,/'"
      sed += "| sed 's/`mature_to` varchar(4) default NULL,/`mature_to` int(4) default NULL,/'"
      sed += "| sed 's/`sequence` blob,/`sequence` longtext,/'"
      
      if (adapter == "postgresql") then
        psql = "psql -h #{host} -d #{database} -U #{username}"
        system("cat #{mirbase_data}tables.sql | #{sed} | #{RAILS_ROOT}/script/mysql_to_postgres.rb | #{psql}") or
          raise("Error reading table definitions: " + $?)
        Dir["#{mirbase_data}*.txt"].each do |f|
          table = (File.basename(f,".txt"))
          puts f
          puts psql
          system("cat #{f} | #{psql} -c \'copy #{table} from stdin\'") or raise ("Error loading miRBase data: " + $?)
        end

      elsif (adapter == "mysql")
        puts "mysql will prompt for your password twice:"
        mysql = "mysql -u #{username} -p #{database}"
        system("cat #{mirbase_data}tables.sql | #{sed} | #{mysql}") or raise ('Error loading table definitions: ' + $?)
        system("mysqlimport -u #{username} -p #{database} -L #{mirbase_data}*.txt") or raise('Error loading miRbase data : ' + $?)
      else
        raise "MirMaid unsupported database: #{adapter}"
      end

    end
  end # :load
end # :mibase
