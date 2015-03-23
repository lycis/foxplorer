#
# This plugin provides a Swing based user interface for the foxplorer.
# requires the use of JRuby
#

require 'java'

import java.awt.event.WindowListener
import javax.swing.JFrame

class GuiWindowListener
  include WindowListener
  def initialize(hookmanager)
    super()
    @hooks = hookmanager
  end

  def windowClosing(evnt)
    print "gui exit"
    @hooks.pull_lever(Hooks::L_SHUTDOWN, ["user requested exit", self])
  end

  def windowActivated(evnt)
  end

  def windowClosed(e)
  end

  def windowDeactivated(e)
  end

  def windowDeiconified(e)
  end

  def windowIconified(e)
  end

  def windowOpened(e)
  end
end

class FoxplorerGui
  def initialize(hookmanager)
    @hooks = hookmanager

    # attach to hooks
    hookmanager.attach_hook(Hooks::H_STARTUP, method(:hook_startup))
    hookmanager.attach_hook(Hooks::H_SHUTDOWN, method(:hook_shutdown))
  end

  def hook_startup(arg)
    # prepare frame
    @frame = JFrame.new
    @frame.visible = true
    @frame.default_close_operation = JFrame::EXIT_ON_CLOSE
    @frame.add_window_listener GuiWindowListener.new(@hooks)
    
    @parentbutton = javax.swing.JButton.new('..')
    @parentbutton.add_action_listener do |event|
      @hooks.pull_lever(Hooks::L_CHDIR, '..')
    end
    
    layout = java.awt.BorderLayout.new
    @frame.set_layout layout
    @frame.add @parentbutton, java.awt.BorderLayout::CENTER
    
  end
  
  def hook_shutdown(args)
    cause = args[0]
    caller = args[1]
    
    return if caller == self
    
    # hide frame
    @frame.visible = false
  end
end