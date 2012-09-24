require "tweetminer/connection"

module TweetMiner

  class Client
    include TweetMiner::Connection

    attr_accessor(*Configuration::VALID_CONFIG_KEYS)

    def initialize(options={})
      merged_options = TweetMiner.options.merge(options)
      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end

  end

end
