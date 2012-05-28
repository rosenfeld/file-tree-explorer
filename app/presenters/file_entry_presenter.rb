require 'delegate'
class FileEntryPresenter < SimpleDelegator
  def as_json
    {
      id: path,
      name: name,
      type: type,
    }
  end
end
