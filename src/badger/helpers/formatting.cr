require "big"

module Helpers::Formatting
  extend self

  BUILD_STATUS_LABEL = "build"
  OPEN_ISSUES_LABEL = "issues"

  def build_status(status : String) : String
    case status
    when .starts_with? "fail" then "failed"
    when "success", "passing" then "passing"
    when "running" then "running"
    when "pending" then "pending"
    when "canceled", "skipped" then "cancelled"
    when "unknown" then "unknown"
    else "invalid"
    end
  end

  def metric(value : Number) : String
    {% begin %}
    case value
    {% metric_prefixes = "kMGPTE" %}
    {% for index in (1..metric_prefixes.size) %}
      {% metric_base = 1 + (metric_prefixes.size - index) %}
      when .>= {{ 1000_u64 ** metric_base }}
        truncated = (value / {{ 1000_u64 ** metric_base }}).round.to_u64.to_s
        truncated + {{ metric_prefixes.chars.[metric_base - 1] }}
    {% end %}
    else
      value.to_s
    end
    {% end %}
  end

  CURRENCY_CODES = {
    "CNY" => "¥",
    "EUR" => "€",
    "GBP" => "₤",
    "USD" => "$",
    "TRY" => "₺",
  }

  def money(value : Number, currency : String) : String
    currency = CURRENCY_CODES[currency]? || currency
    "#{currency}#{value}"
  end
end
