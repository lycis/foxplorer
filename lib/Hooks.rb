class Hooks
  # constants for system hooks
  H_STARTUP = "startup" # indicatest that the application was successfully started
  H_SHUTDOWN = "shutdown" # signals that the application is going to shut down
  def initialize
    @hook_register = Hash.new(nil)
    @lever_register = Hash.new(nil)
  end

  # attach to a hook
  def attach_hook(hook, method)
    if @hook_register[hook] != nil
      @hook_register[hook].push method
    else
      @hook_register[hook] = [method]
    end
  end

  # fire a hook
  def activate_hook(hook, args)
    return unless @hook_register[hook] != nil # nothing to invoke when no one is interested

    @hook_register[hook].each do |method|
      method[args]
    end
  end

  # register a new lever that can be pulled
  # lever is the name of the lever
  # method is the method that will be called when pulled
  def provide_lever(lever, method)
    if @lever_register[lever] != nil
      @lever_register[lever].push method
    else
      @lever_register[lever] = [method]
    end
  end

  # activates a lever
  def pull_lever(lever, args)
    raise "unknown lever #{lever}" unless @lever_register[lever] != nil

    @lever_register[lever].each do |method|
      method[args]
    end
  end

end