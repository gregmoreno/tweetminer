require "bundler"
Bundler.require

TweetMiner.configure do |config|
  settings = YAML.load_file File.dirname(__FILE__) + "/mongo.yml"

  config.host     = settings["host"]
  config.port     = settings["port"]
  config.database = settings["database"]
end

miner = TweetMiner::Client.new


require "rgl/adjacency"
require "rgl/dot"

graph = RGL::DirectedAdjacencyGraph.new

miner.mentions_by_user.fetch("results").each do |user|
  user.fetch("value").fetch("mentions").each do |mention|
    graph.add_edge(user.fetch("_id"), mention)
  end
end

# create graph.dot, graph.png
graph.write_to_graphic_file

