extendClass 'specs.FileTreeSpec', (spec)->
  loadedTreeContext: ->
    @before -> @fakeServer.ignoreAllRequests()

    @it 'opens directory', ->
      $('#file-tree > ul > li:eq(0) > div').click()
      @waitsForAjaxRequest()
      @runs ->
        @nextRequest Routes.children_path(node: 'app')
        $('#file-tree > ul > li:eq(0) li > div').click()
      @waitsForAjaxRequest()
      @runs -> @checkRequestSettings Routes.children_path(node: 'app/model')
        .replace('%2F', '/') # jqTree is buggy when id is not numeric

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

