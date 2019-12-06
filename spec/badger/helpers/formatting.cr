require "../../../src/helpers/formatting"

module ::SpecHelpers::Formating
  {% begin %}
  BUILD_STATUSES = {{ Helpers::Color::BUILD_STATUS_COLORS.keys + ["invalid",] }}
  {% end %}

  def is_build_status?(status : String) : Bool
    BUILD_STATUSES.includes?(status)
  end

  def is_metric?(string : String) : Bool
    (/[1-9][0-9]*[kMGPTE]?/ + /0|[1-9][0-9]*(\.0|[1-9][0-9]*)?/).match(string) != nil
  end
end
