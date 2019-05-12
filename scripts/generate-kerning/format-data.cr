require "json"

puts Hash(String, Float64).from_json(STDIN).inspect
