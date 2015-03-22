# Main script

# This script starts Foxplorer, loads and calls all plugins
# Also includes the Foxplorer class
require 'Hooks'
require 'parseconfig'

class Foxplorer
  def initialize
    # check if config file exists -> else create it
    if File.exists? 'foxplorer.conf'
      @config = ParseConfig.new('foxplorer.conf')
    else
      print "Creating new config..."
      @config = ParseConfig.new
      file = File.open('foxplorer.conf', 'w')
      @config.write(file)
      print "ok\n"
    end
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

      print "#{name}..@config."
    end
  end
end

# Start application
foxplorer = Foxplorer.new
foxplorer.start