# Collects user tweets and saves them to a mongodb

require "bundler"
Bundler.require

require File.dirname(__FILE__) + "/tweetminer"

# We use the TweetStream gem to access Twitter's Streaming API.
# https://github.com/intridea/tweetstream

TweetStream.configure do |config|
  settings = YAML.load_file File.dirname(__FILE__) + '/twitter.yml'

  config.consumer_key       = settings['consumer_key']
  config.consumer_secret    = settings['consumer_secret']
  config.oauth_token        = settings['oauth_token']
  config.oauth_token_secret = settings['oauth_token_secret']
end

settings = YAML.load_file File.dirname(__FILE__) + '/mongo.yml'
miner = TweetMiner.new(settings)

stream = TweetStream::Client.new

stream.on_error do |msg|
  puts msg
end

stream.on_timeline_status do |status|
  miner.insert_status status
  print "."
end

# Do not forget this to trigger the collection of tweets
stream.userstream
