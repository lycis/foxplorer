require_relative '../lib/Hooks'
Dir[File.join('plugins/', "*.rb")].each {|file| require_relative "../#{file}" }
require 'parseconfig'

# This is the class that manages everything of the foxplorer
class Foxplorer
  def initialize
    # check if config file exists -> else create it
    if File.exists? Dir.home+'/foxplorer.conf'
      @config = ParseConfig.new(Dir.home+'/foxplorer.conf')
    else
      print "Creating new config..."
      @config = ParseConfig.new
      file = File.open(Dir.home+'/foxplorer.conf', 'w')
      @config.write(file)
      print "ok\n"
    end

    # initialise hook register
    @hooks = Hooks.new
  end

  # Start the application
  def start
    load_plugins unless @config['plugins'] == nil
  end

  # load all enabled plugins
  def load_plugins
    print "Enabled plugins:\n"
    @config['plugins'].each do |name,state|
      next if state == '0'
      print "#{name}... "

      # instantiate plugin class
      begin
      clazz = Object.const_get("Foxplorer#{name.capitalize}")
      plugin = clazz.new(@hooks)
        print "ok\n"
      rescue Exception => error
        print "error: #{error}\n"
      end
    end
  end
end
