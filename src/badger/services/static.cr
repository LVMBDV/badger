require "../helpers/service"

include Helpers::Service

define_service "static" do
  {% for option in ["colorscheme", "label_color", "value_color", "logo", "label", "value", "link", "label_link", "value_link"] %}
    env.params.query[{{option}}]?.try { |val| badge.{{option.id}} = val }
  {% end %}
end
