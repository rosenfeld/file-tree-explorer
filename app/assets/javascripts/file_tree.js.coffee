# =require ./file_tree/routes
$ -> new FileTree

(exports ? window).FileTree = class FileTree
  constructor: ->
    @initializeTree()
    $('#content').dialog(width: 800, height: 600, autoOpen: false)

  initializeTree: ->
    $.getJSON routes.root_path, (@rootEntries)=>
      @processEntries(@rootEntries)
      @createTree()

  processEntries: (entries)->
    for entry in entries when entry.type is 'directory'
      entry.unfetched = true
      entry.children = [label: 'loading...']

  createTree: ->
    @tree = $('#file-tree').tree(data: @rootEntries, autoOpen: false)
      .bind('tree.click', @onNodeClick)
      .bind('tree.open', @onNodeOpen)

  onNodeClick: (e)=>
    (@tree.tree 'toggle', e.node; return) if e.node.type is 'directory'
    $.post routes.content_path, path: e.node.id, (content)->
      $('#content').text(content).dialog('option', 'title', e.node.id).dialog('open')

  onNodeOpen: (e)=>
    return unless (node = e.node).unfetched
    delete node.unfetched
    $.post routes.children_path, path: node.id, (children)=>
      node.children = []
      @processEntries children
      @tree.tree 'loadData', children, node
