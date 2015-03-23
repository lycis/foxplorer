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

    provide_levers

    # signal that the startup is done
    @hooks.activate_hook(Hooks::H_STARTUP, nil)
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
        abort
      end
    end
  end

  # register all system levers for the application
  def provide_levers
    @hooks.provide_lever("shutdown", method(:sys_lever_shutdown))
  end

  # system lever to shutdown the application
  def sys_lever_shutdown(args)
    cause = args[0]
    caller = args[1]
    
    # signal shutdown to everyone
    @hooks.activate_hook(Hooks::H_SHUTDOWN, [cause, caller])

    # TODO update configuration
    java.lang.System.exit(0)
  end

  private :provide_levers, :load_plugins
end
