require "json"
require "spec"
require "spec-kemal"
require "../src/badger"
require "../src/badger/badge"

macro with_json_badge(path, &block)
  get {{path + "&format=json"}}
  response = Global.response.not_nil!
  badge = Badge.from_json(response.body)
  {{block.body}}
end
