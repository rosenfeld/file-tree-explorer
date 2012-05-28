class FileTreeController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render_entries_json }
    end
  end

  def children
    render_entries_json params[:path]
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
