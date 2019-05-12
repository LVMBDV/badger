require "kemal"

require "../badge"
require "./rendering"

include Helpers::Rendering

module Helpers::Service
  macro define_service(name, &block)
    get "/{{name.split.join('-').id}}/{{ block.args.map { |arg| ":" + arg.stringify }.join('/').id }}" do |env|
      style = env.params.query["style"]?
      badge = Badge.default

      {% for arg in block.args %}
        {{arg}} = env.params.url[{{arg.stringify}}]
      {% end %}

      {{block.body}}

      case env.params.query["format"]?
      when "json"
        env.response.content_type = "application/json"
        badge.to_json
      when "svg", nil
        env.response.content_type = "image/svg+xml"
        render_badge(badge, style)
      else
        env.response.content_type = "image/svg+xml"
        render_badge(Badge.not_found, style)
      end
    end
  end
end
