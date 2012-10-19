JsRoutes.setup do |config|
  config.default_format = :json
end if defined? JsRoutes # not defined in production-like environments
