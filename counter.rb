require "bundler"
Bundler.require

require File.dirname(__FILE__) + "/tweetminer"

settings = YAML.load_file File.dirname(__FILE__) + '/mongo.yml'
miner = TweetMiner.new(settings)

#results = miner.status_count_by_user
results = miner.status_count_by_hday
ap results
