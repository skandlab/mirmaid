
def with_local_server(&block)
  # setup server
  begin
    if ENV['MIRMAID_URL']
      # use running server: MIRMAID_URL=http://current.mirmaid.org rake mirmaid:test:rest
      puts "testing RESTful API on server running at URL: " + ENV['MIRMAID_URL']
      yield
    else
      # start server
      ENV['MIRMAID_URL'] = "http://localhost:3023/"
      puts "testing RESTful API at URL: " + ENV['MIRMAID_URL']
      puts "starting server ..."
      pipe = IO.popen("script/server -p 3023 -e #{ENV["RAILS_ENV"]}")
      sleep 2
      yield
    end
  rescue
    puts "Errors were caught: " + $!
  ensure
    Process.kill 'INT', pipe.pid if !pipe.nil?
  end
end

namespace :mirmaid do
  namespace :test do

    desc "Run MirMaid core framework unit tests (in test/unit)"
    task :units do
      puts ">> Testing: MirMaid core unit tests"
      Rake::TestTask.new(:core_units) do |t|
        t.libs << "test"
        t.pattern = 'test/unit/**/*_test.rb'
        t.verbose = false
        # to use multiple paptterns,
        # FileList['test/**/*_test.rb']
      end
      Rake::Task['core_units'].invoke
    end
    
    desc "Test RESTful API on local server or MIRMAID_URL"
    task :rest do
      Rake::TestTask.new(:rest_units) do |t|
        t.libs << "test"
        t.pattern = 'test/rest/**/*_test.rb'
        t.verbose = false
      end

      puts ">> Testing: MirMaid core REST tests"
      with_local_server { Rake::Task[:rest_units].invoke }
    end
    
    desc "Run the plugin tests in vendor/plugins/mirmaid*/**/test (specify plugin with PLUGIN=name)"
    task :plugin_units do
      Rake::TestTask.new(:pu) do |t|
        t.libs << "test"
        t.pattern = ENV['PLUGIN'] ? "vendor/plugins/#{ENV['PLUGIN']}/test/unit/**/*_test.rb" : 'vendor/plugins/mirmaid*/**/test/unit/**/*_test.rb'
        t.verbose = false
      end
      if ENV['PLUGIN']
        puts ">> Testing: unit tests in MirMaid plugin " + ENV['PLUGIN']        
      else
        puts ">> Testing: unit tests in all MirMaid plugins"
      end
      Rake::Task[:pu].invoke
    end

    desc "Test all plugin RESTful API's on local server or MIRMAID_URL (specify plugin with PLUGIN=nam)"
    task :plugin_rest do
      Rake::TestTask.new(:ru) do |t|
        t.libs << "test"
        if ENV['PLUGIN']
          puts ">> Testing: REST test of MirMaid plugin " + ENV['PLUGIN']
          t.pattern = "vendor/plugins/#{ENV['PLUGIN']}/test/rest/**/*_test.rb"
        else
          puts ">> Testing: REST tests in all MirMaid plugins"
          t.pattern = 'vendor/plugins/mirmaid*/**/test/rest/**/*_test.rb'
        end
        t.verbose = false
      end

      with_local_server { Rake::Task[:ru].invoke }
    end
    
    desc 'Run all unit, rest and plugin tests'
    task :all do
      puts ">> Testing, running all tests"
      with_local_server do
        errors = %w(mirmaid:test:units mirmaid:test:rest mirmaid:test:plugin_units mirmaid:test:plugin_rest).collect do |task|
          begin
            Rake::Task[task].invoke
            nil
          rescue => e
            task
          end
        end.compact
        abort "Errors running #{errors.to_sentence}!" if errors.any?
      end
    end
    
  end

end

