require "json"

require "../helpers/service"
require "../helpers/formatting"

include Helpers::Service

{% for resource in ["receives", "gives", "patrons", "goal", "goal progress"] %}
define_service "liberapay/{{resource.id}}" do |user|
  url = "https://liberapay.com/#{user}/public.json"
  badge.label = {{resource}}

  response = HTTP::Client.get(url)
  if response.status_code == 200
    data = JSON.parse(response.body)
    receiving = data["receiving"]["amount"].as_s.to_f
    giving = data["giving"]["amount"].as_s.to_f
    goal = data["goal"].as_h?.try { |goal_data| goal_data["amount"].as_s?.try { |amount| amount.to_f } }
    currency = data["giving"]["currency"].as_s
    patrons = data["npatrons"].as_i
    goal_percent = (goal ? (receiving / goal) : 1.0) * 100

    {% if resource == "receives" %}
      badge.value = Helpers::Formatting.money(receiving, currency) + "/week"
      badge.colorscheme = Helpers::Color.percent(goal_percent)
    {% elsif resource == "gives" %}
      badge.value = Helpers::Formatting.money(giving, currency) + "/week"
      badge.colorscheme = Helpers::Color.not_zero(giving)
    {% elsif resource == "patrons" %}
      badge.value = Helpers::Formatting.metric(patrons)
      badge.colorscheme = Helpers::Color.not_zero(patrons)
    {% elsif resource == "goal" %}
      badge.value = Helpers::Formatting.money(goal || 0, currency)
      badge.colorscheme = Helpers::Color.percent(goal_percent)
    {% elsif resource == "goal progress" %}
      badge.value = goal_percent.round(1).to_s + '%'
      badge.colorscheme = Helpers::Color.percent(goal_percent)
    {% end %}
  else
    badge.value = "unknown"
  end
end
{% end %}
