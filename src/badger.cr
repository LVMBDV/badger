require "kemal"
require "option_parser"

require "./badger/badge"
require "./badger/services/*"
require "./badger/helpers/rendering"

port = 8080

error 404 do |env|
  env.response.content_type = "image/svg+xml"
  Helpers::Rendering.render_badge(Badge.not_found)
end

OptionParser.parse do |opts|
  opts.on("-p PORT", "--port PORT", "define port to run server") do |opt|
    port = opt.to_i
  end
end

Kemal.run(port)
