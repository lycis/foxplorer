class Hooks
  # constants for system hooks
  H_STARTUP = "startup" # start of the application
  H_SHUTDOWN = "shutdown" # end of application
  
  def initialize
    @hook_register = Hash.new(nil)
  end
  
  # attach to a hook
  def attach_hook(hook, method)
    if @hook_register[hook] != nil
      @hook_register[hook].push method
    else
      @hook_register[hook] = [method]
    end
  end
  
end