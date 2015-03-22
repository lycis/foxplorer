module Hooks
  # constants for system hooks
  H_STARTUP = "startup" # start of the application
  H_SHUTDOWN = "shutdown" # end of application
  
  def foo
    print "bar\n"
  end
end