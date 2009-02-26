require 'net/http'
require 'uri'
require 'rubygems'
require 'progressbar'
require 'config/environment'

#Settings
mirbase_version = "CURRENT" # specify version
# specify location of mirbase is available locally
# the database files have to be unzipped!
mirbase_dir   = "/data1/genome_seq/mirbase/mirror"
mirbase_data = "#{mirbase_dir}/#{mirbase_version}/database_files/"
#require 'net/ftp'
#mirbase_ftp = "ftp://ftp.sanger.ac.uk/pub/mirbase/sequences/"

#############
### Tasks
#############

namespace :mibase do

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

    desc 'Drops, creates, migrates and loads data for the database defined by RAILS_ENV.'
    task :reset => [
      'mibase:db:drop',
      'mibase:db:create',
      'mibase:load:mirbase',
      'db:migrate']

  end # :db
  
  namespace :load do

    desc "[1] load raw miRBase tables and data"
    task :mirbase  => :environment do

      puts "Loading miRBase ..."

      db_config = ActiveRecord::Base.configurations[RAILS_ENV]
      adapter  = db_config['adapter']
      host     = db_config['host']
      database = db_config['database']
      username = db_config['username']
      password = db_config['password']

      puts db_config[RAILS_ENV].to_yaml
      
      raise "error reading #{mirbase_data} txt.files, remember to unzip files" if Dir["#{mirbase_data}*.txt"].size <= 10
      
      # make initial schema changes
      sed = ""
      sed = "sed 's/`mature_from` varchar(4) default NULL,/`mature_from` int(4) default NULL,/'"
      sed += "| sed 's/`mature_to` varchar(4) default NULL,/`mature_to` int(4) default NULL,/'"
      
      if (adapter == "postgresql") then
        psql = "psql -h #{host} -d #{database} -U #{username}"
        system("cat #{mirbase_data}tables.sql | #{sed} | #{RAILS_ROOT}/script/mysql_to_postgres.rb | #{psql}") or
          raise("Error reading tables.sql")
        Dir["#{mirbase_data}*.txt"].each do |f|
          table = (File.basename(f,".txt"))
          puts f
          puts psql
          system("cat #{f} | #{psql} -c \'copy #{table} from stdin\'") or raise ("Error loading miRBase data")
        end

      elsif (adapter == "mysql")
        puts "mysql will prompt for your password twice:"
        mysql = "mysql -u #{username} -p #{database}"
        system("cat #{mirbase_data}tables.sql | #{sed} | #{mysql}") or raise 'error loading tables definitions'
        system("mysqlimport -u #{username} -p #{database} -L #{mirbase_data}*.txt") or raise 'Error loading miRbase data'
      else
        raise "unsupported database: #{adapter}"
      end

    end
  end # :load
end # :mibase
