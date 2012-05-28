class FileEntry
  attr_reader :name, :type, :path

  def initialize(path = '.')
    @path = path
    @full_path = Rails.root.join path
    @name = @full_path.basename.to_s
    @type = @full_path.ftype
  end

  def children
    @full_path.children.sort.map{|c| FileEntry.new relative_path(c) }
  end

  def content
    return 'Unsupported type' unless supported?
    return 'Too big to be displayed' if too_big?
    @full_path.read
  end

  def supported?
    @name !~ /\.(png|jpg|ico|sw.)$/i
  end

  def visible?
    supported? and @name !~ /^(\.|tmp)/
  end

  private

  def relative_path(c)
    c.relative_path_from(Rails.root).to_s
  end

  def too_big?
    @full_path.size > 40_000
  end
end
