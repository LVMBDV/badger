module ::Helpers::Color
  extend self

  COLORS = {
    "red"         => "#E05D44",
    "green"       => "#97CA00",
    "blue"        => "#007EC6",
    "gray"        => "#555",
    "lightgray"   => "#9F9F9F",
    "brightgreen" => "#4C1",
    "yellowgreen" => "#A4A61D",
    "yellow"      => "#DFB317",
    "orange"      => "#FE7D37",
  }

  DEFAULT_LABEL_COLOR = COLORS["gray"]

  def valid_color?(color : String) : Bool
    COLORS.has_key?(color) || (
      color.starts_with?('#') &&
      [4,7].includes?(color.size) &&
      color.each_char.skip(1).all? { |char| char.ascii_number? 16 }
    )
  end

  def resolve_color(color : String) : String
    raise "invalid color #{color}" unless valid_color? color
    COLORS[color]? || color
  end

  def sanitize_color(color : String)
    color = "lightgray" unless valid_color?(color)
    resolve_color(color)
  end

  COLOR_SCALE = ["red", "orange", "yellow", "yellowgreen", "green", "brightgreen"]

  def percent(number : Number, more_is_good = true)
    index = Math.min(COLOR_SCALE.size - 1, (number / 100.0) * COLOR_SCALE.size).round.to_i
    (more_is_good ? COLOR_SCALE : COLOR_SCALE.reverse)[index]
  end

  def not_zero(number : Number)
    number == 0 ? "red" : "brightgreen"
  end

  BUILD_STATUS_DEFAULT_COLOR = "lightgray"
  BUILD_STATUS_COLORS = {
    "passing" => "brightgreen",
    "running" => "green",
    "pending" => "yellow",
    "cancelled" => "orange",
    "failed" => "red",
    "unknown" => "lightgray",
  }

  def build_status(status : String)
    BUILD_STATUS_COLORS[status]? || BUILD_STATUS_DEFAULT_COLOR
  end

  def open_issues(number : Int)
    number == 0 ? "brightgreen" : "yellow"
  end
end
