require "tweetminer/configuration"
require "tweetminer/client"

module TweetMiner
  extend Configuration

  def new(options={})
    Client.new(options)
  end

end
