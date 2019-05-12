require "../badge"
require "./style"

module ::Helpers::Rendering
  extend self

  def render_badge(badge : Badge, style : String? = nil)
    buffer = IO::Memory.new

    unless Helpers::Style::AVAILABLE_BADGE_STYLES.includes? style
      style = Helpers::Style::AVAILABLE_BADGE_STYLES[0]
    end

    {% begin %}
    case style
    {% for st in Helpers::Style::AVAILABLE_BADGE_STYLES %}
    when {{st}}
      ECR.embed("res/templates/{{st.id}}.svg.ecr", buffer)
    {% end %}
    end
    {% end %}

    buffer.to_s
  end
end
