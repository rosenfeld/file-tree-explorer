$ -> new FileTree

(exports ? window).FileTree = class FileTree
  constructor: ->
    @createTree()
    $('#content').dialog(width: 800, height: 600, autoOpen: false)

  createTree: ->
    @tree = $('#file-tree').tree(autoOpen: false).bind('tree.click', @onNodeClick)

  onNodeClick: (e)=>
    (@tree.tree 'toggle', e.node; return) if e.node.type is 'directory'
    $.post Routes.content_path(), path: e.node.id, (content)->
      $('#content').text(content).dialog('option', 'title', e.node.id).dialog('open')
