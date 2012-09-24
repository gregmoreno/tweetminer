require "bundler"
Bundler.require

TweetMiner.configure do |config|
  settings = YAML.load_file File.dirname(__FILE__) + "/mongo.yml"

  config.host     = settings["host"]
  config.port     = settings["port"]
  config.database = settings["database"]
end

miner  = TweetMiner::Client.new

#results = miner.status_count_by_user
#results = miner.status_count_by_hday
results = miner.status_count_by_wday
ap results
