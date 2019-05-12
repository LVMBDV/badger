require "../../../src/helpers/formatting"

module SpecHelpers::Formating
  BUILD_STATUSES = [
    "failed",
    "passing",
    "running",
    "pending",
    "cancelled",
    "unknown",
    "invalid",
  ]

  def is_build_status?(status : String) : Bool
    BUILD_STATUSES.includes?(status)
  end

  def is_metric?(string : String) : Bool
    (/[1-9][0-9]*[kMGPTE]?/ + /0|[1-9][0-9]*(\.0|[1-9][0-9]*)?/).match(string) != nil
  end
end
