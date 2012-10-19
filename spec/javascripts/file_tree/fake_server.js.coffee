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
#        when 'json' then switch settings.type?.toUpperCase()
#          when 'GET' then switch settings.url
#          when 'POST' then switch settings.url
#           when ...
        when undefined then switch settings.type?.toUpperCase()
#         when 'GET' then switch settings.url
#           when ...
          when 'POST' then switch settings.url
            when Routes.content_path()
              handled = true
              settings.success "content for #{settings.data.path}"
            when Routes.children_path() then switch settings.data.path
              when undefined then handled = true; settings.success rootEntries()
              when 'app' then handled = true; settings.success appEntries()
#         when undefined then switch settings.url
#           when ...

      return if handled
      console.log arguments
      throw "Unexpected AJAX call: #{settings.url}"
