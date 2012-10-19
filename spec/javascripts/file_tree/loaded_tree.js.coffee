extendClass 'specs.FileTreeSpec', (spec)->
  loadedTreeContext: ->
    @before -> @fakeServer.ignoreAllRequests()

    @it 'opens directory', ->
      $('#file-tree > ul > li:eq(0) > div').click()
      @waitsForAjaxRequest()
      @runs ->
        @checkChildrenRequest 'app'
        $('#file-tree > ul > li:eq(0) li > div').click()
      @waitsForAjaxRequest()
      @runs -> @checkChildrenRequest 'app/model', false

    @it 'loads file content in a pop-up dialog', ->
      $('#content').empty()
      $('#file-tree > ul > li:eq(1) > div').click()
      content = ''
      @waitsForAjaxRequest()
      @runs -> @nextRequest Routes.content_path(), 'post'
      @waitsFor -> content = $('#content').text()
      @runs ->
        @expect(content).toBe 'content for README'
        @expect($('#content')).toBeVisible()
        $('#content').siblings('.ui-dialog-titlebar:first').find('a.ui-dialog-titlebar-close').click()
        @expect($('#content')).not.toBeVisible()

  checkChildrenRequest: (path, should_process = true)->
    @checkRequestSettings Routes.children_path()
    @expect(@ajaxSettings().data.node).toBe path
    @fakeServer.processNextRequest() if should_process
