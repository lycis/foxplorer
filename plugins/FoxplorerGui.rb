#
# This plugin provides a Swing based user interface for the foxplorer.
#

class FoxplorerGui
  def initialize(hookmanager)
    # attach to hooks
    hookmanager.attach_hook(Hooks::H_STARTUP, method(:hook_startup))
      
    raise "not implemented"
  end
  
  def hook_startup
  end
end