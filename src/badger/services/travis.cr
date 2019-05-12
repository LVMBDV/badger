require "http/client"
require "json"

require "../helpers/service"
require "../helpers/formatting"
require "../helpers/color"

include Helpers::Service

private def get_travis_status(tld : String, user : String, repo : String, branch : String? = nil)
  url = "https://api.travis-ci.#{tld}/#{user}/#{repo}.svg"
  url += "?branch=#{branch}"

  response = HTTP::Client.get(url)
  if response.status_code == 200
    state = response.headers["content-disposition"].match(/filename="(.+)\.svg"/).not_nil![1]
  else
    state = "unknown"
  end

  state
end

{% for tld in ["com", "org"] %}
define_service "travis-{{tld.id}}" do |user, repo|
  badge.label = Helpers::Formatting::BUILD_STATUS_LABEL
  status = get_travis_status({{tld}}, user, repo)
  badge.link = "https://travis-ci.org/rust-lang/rust" unless status == "unknown"
  badge.value = Helpers::Formatting.build_status(status)
  badge.colorscheme = Helpers::Color.build_status(status)
end

define_service "travis-{{tld.id}}" do |user, repo, branch|
  badge.label = Helpers::Formatting::BUILD_STATUS_LABEL
  status = get_travis_status({{tld}}, user, repo)
  badge.link = "https://travis-ci.org/rust-lang/rust" unless status == "unknown"
  badge.value = Helpers::Formatting.build_status(status)
  badge.colorscheme = Helpers::Color.build_status(status)
end
{% end %}
