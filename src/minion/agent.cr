require "option_parser"
require "minion-common"
require "./client"
require "./agent/*"

action : String = ""

Minion::StatsRecord = Minion::Agent::Stats.new
Minion::ConfigSource = ENV.has_key?("CONFIG") ? File.open(ENV["CONFIG"], "a+") : IO::Memory.new("---\n")

OptionParser.new do |opts|
  opts.on("-t", "--test", "Test the agent to make sure it works and can connect/authenticate with MINION") do
    action = "test"
  end

  opts.on("-r", "--run", "Run the agent in normal production mode (remember to specify CONFIG=/path/to/config.yml as an env var first)") do
    action = "run"
  end

  opts.on("-u", "--upgrade", "Upgrade the minion agent to the latest version") do
    action = "upgrade"
  end

  opts.on("-v", "--version", "Show agent version") do
    action = "version"
  end
end.parse

case action
when "test"
  Minion::Agent.test
when "upgrade"
  Minion::Agent.upgrade!
when "version"
  puts Minion::Agent::VERSION
else
  Minion::Agent.run
end
