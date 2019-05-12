require "ecr/macros"
require "html"
require "json"

require "./helpers/color"
require "./helpers/kerning"

struct Badge
  JSON.mapping(
    label: String,
    value: String,
    label_link: String?,
    value_link: String?,
    label_color: String,
    value_color: String,
    logo: String?,
    padding: Float64
  )

  @label_link = nil
  @value_link = nil
  @logo = nil
  @padding = 5.5

  def initialize(@label, @value, colorscheme = "lightgray")
    @label_color = Helpers::Color::DEFAULT_LABEL_COLOR
    @value_color = Helpers::Color.sanitize_color(colorscheme)
  end

  def colorscheme=(color : String)
    @label_color = Helpers::Color::DEFAULT_LABEL_COLOR
    @value_color = Helpers::Color.sanitize_color(color)
  end

  def link=(link : String)
    @label_link = link
    @value_link = link
  end

  {% for member in ["label", "value"].map { |name| name.id } %}
  def {{member}}_color=(color : String)
    @{{member}}_color = Helpers::Color.resolve_color(color)
  end

  def {{member}}_text_width
    Helpers::Kerning.text_width(@{{member}})
  end

  def {{member}}_width
    {{member}}_text_width + (padding * 2)
  end

  def {{member}}_escaped
    HTML.escape @{{member}}
  end
  {% end %}

  def total_width
    label_width + value_width
  end

  def self.not_found
    Badge.new("badge", "not found", "red")
  end

  def self.default
    Badge.new("label", "value", "lightgray")
  end
end
