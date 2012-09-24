# Collects user tweets and saves them to a mongodb

require "bundler"
Bundler.require

# We use the TweetStream gem to access Twitter's Streaming API.
# https://github.com/intridea/tweetstream

TweetStream.configure do |config|
  settings = YAML.load_file File.dirname(__FILE__) + "/twitter.yml"

  config.consumer_key       = settings["consumer_key"]
  config.consumer_secret    = settings["consumer_secret"]
  config.oauth_token        = settings["oauth_token"]
  config.oauth_token_secret = settings["oauth_token_secret"]
end

TweetMiner.configure do |config|
  settings = YAML.load_file File.dirname(__FILE__) + "/mongo.yml"

  config.host     = settings["host"]
  config.port     = settings["port"]
  config.database = settings["database"]
end


stream = TweetStream::Client.new
miner  = TweetMiner::Client.new

stream.on_error do |msg|
  puts msg
end

#stream.on_timeline_status do |status|
stream.track("RT") do |status|
  miner.insert_status status
  print "."
#  ap status
end

# Do not forget this to trigger the collection of tweets
stream.userstream
