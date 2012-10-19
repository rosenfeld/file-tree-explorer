$ -> new FileTree

(exports ? window).FileTree = class FileTree
  constructor: ->
    @createTree()
    $('#content').dialog(width: 800, height: 600, autoOpen: false)

  createTree: ->
    @tree = $('#file-tree').tree({@dataUrl}).bind('tree.click', @onNodeClick)

  dataUrl: (node)-> url: Routes.children_path(), method: 'post', data: { path: node?.id }

  onNodeClick: (e)=>
    (@tree.tree 'toggle', e.node; return) if e.node.type is 'directory'
    $.post Routes.content_path(), path: e.node.id, (content)->
      $('#content').text(content).dialog('option', 'title', e.node.id).dialog('open')
