require "http/client"
require "json"

require "../helpers/service"
require "../helpers/formatting"
require "../helpers/color"

include Helpers::Service

private def get_bitbucket_issues(user : String, repo : String)
  url = "https://bitbucket.org/api/1.0/repositories/#{user}/#{repo}/issues?limit=0&status=new&status=open"

  response = HTTP::Client.get(url)
  if response.status_code == 200
    issues = JSON.parse(response.body).as_h["count"].as_i
  end

  issues
end

define_service "bitbucket/issues" do |user, repo|
  badge.label = Helpers::Formatting::OPEN_ISSUES_LABEL
  issues = get_bitbucket_issues(user, repo)

  if issues.nil?
    badge.value = "unknown"
  else
    badge.value = Helpers::Formatting.metric(issues)
    badge.colorscheme = Helpers::Color.open_issues(issues)
  end
end
