class FileTreeController < ApplicationController
  def index
  end

  def children
    render_entries_json params[:node] || '.'
  end

  def content
    render text: FileEntry.new(params[:path]).content
  end

  private

  def render_entries_json(path = '.')
    render json: FileEntry.new(path).children.find_all(&:visible?).
      map{|e| FileEntryPresenter.new(e).as_json }
  end
end
