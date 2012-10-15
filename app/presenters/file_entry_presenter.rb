require 'delegate'
class FileEntryPresenter < SimpleDelegator
  def as_json
    {
      id: path,
      label: name,
      type: type,
      load_on_demand: type == 'directory',
    }
  end
end
