# =require fake_ajax_server

rootEntries = -> [
  { id: 'app',    label: 'app',    type: 'directory', load_on_demand: true }
  { id: 'README', label: 'README', type: 'file',      load_on_demand: false }
]

appEntries = -> [
  { id: 'app/model', label: 'model', type: 'directory', load_on_demand: true }
]

extendClass 'specs.FileTreeSpec', ->
  createFakeServer: ->
    @fakeServer = new FakeAjaxServer (url, settings)->
      if settings then settings.url = url else settings = url
      handled = false
      switch settings.dataType
#        when 'json' then switch settings.type
#          when 'get' then switch settings.url
#          when 'post' then switch settings.url
#           when ...
        when undefined then switch settings.type
#         when 'get' then switch settings.url
#           when ...
          when 'post' then switch settings.url
            when Routes.content_path()
              handled = true
              settings.success "content for #{settings.data.path}"
          when undefined then switch settings.url
            when Routes.children_path() then handled = true; settings.success rootEntries()
            when Routes.children_path(node: 'app') then handled = true; settings.success appEntries()

      return if handled
      console.log arguments
      throw "Unexpected AJAX call: #{settings.url}"
