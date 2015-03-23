# contains one folder and its state. provides access to the file list and provides
# hooks and levers to operate on the folder list and files
class FolderState
  def initialize(path)
    @history = [path]
  end
  
  # gives the current location
  def current_location
    return @history[-1]
  end
  
  # change the current location
  def change_location(target)
    @history.push target
    #TODO change used accessor
  end
  
end