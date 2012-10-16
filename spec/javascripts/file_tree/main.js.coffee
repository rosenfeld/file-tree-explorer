extendClass 'specs.FileTreeSpec', (spec)->
  initialize: ->
    @createFakeServer()
    @extend this, new specs.oojspec.AjaxHelpers(@fakeServer)

  runSpecs: ->
    @beforeAll -> @fakeServer.start()
    @afterAll -> @fakeServer.stop()

    @beforeAll ->
      @specsContainer = $('<div id=specs_container/>').prependTo('body').hide()
        .html("<div id=file-tree></div><pre id=content></pre>")
      new FileTree

    @afterAll  -> @specsContainer.remove()

    @it "requests root entries", ->
      @refute $('#file-tree *').length
      @waitsForAjaxRequest()
      @runs ->
        @nextRequest Routes.children_path()
        @assert $('#file-tree > ul > li').length is 2
        @expect($('#file-tree > ul > li:eq(0)')).toHaveText '►app'
        @expect($('#file-tree > ul > li:eq(1)')).toHaveText 'README'

    @context "loaded tree", @loadedTreeContext
