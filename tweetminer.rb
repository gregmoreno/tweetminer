require "mongo"

require File.dirname(__FILE__) + "/status_counter"

class TweetMiner
  include StatusCounter

  attr_writer :db_connector
  attr_reader :options

  def initialize(options)
    @options = options
  end

  def db
    @db ||= connect_to_db
  end

  def insert_status(status)
    statuses.insert status
  end

  def statuses
    @statuses ||= db["statuses"]
  end

  private

  def connect_to_db
    db_connector.call(options["host"], options["port"]).db(options["database"])
  end

  def db_connector
    @db_connector ||= Mongo::Connection.public_method :new
  end

end
