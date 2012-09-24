module TweetMiner

  module Configuration
    VALID_CONNECTION_KEYS = [:host, :port, :database]

    VALID_CONFIG_KEYS = VALID_CONNECTION_KEYS

    DEFAULT_HOST     = "localhost"
    DEFAULT_PORT     = "27017"
    DEFAULT_DATABASE = "twitter"

    attr_accessor(*VALID_CONFIG_KEYS)

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def options
      Hash[ *VALID_CONFIG_KEYS.map { |key| [key, send(key)] }.flatten ]
    end

    def reset
      self.host     = DEFAULT_HOST
      self.port     = DEFAULT_PORT
      self.database = DEFAULT_DATABASE
    end

  end

end
