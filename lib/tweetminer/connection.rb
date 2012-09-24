require "mongo"

module TweetMiner

  module Connection

    def insert_status(status)
      statuses.insert status
    end

    def statuses
      @statuses ||= db["statuses"]
    end

    def db
      @db ||= connect_to_db
    end

    def connect_to_db
      db_connector.call(self.host, self.port).db(self.database)
    end

    def db_connector
      @db_connector ||= Mongo::Connection.public_method :new
    end

  end

end
