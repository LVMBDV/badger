module Helpers::Style
  extend self

  {% begin %}
  AVAILABLE_BADGE_STYLES = {{ `ls -1 res/templates`.strip.split("\n").map { |fname| fname.gsub(/\..+$/, "") } }}
  {% end %}
end
