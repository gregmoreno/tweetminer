require "bundler"
Bundler.require

require File.expand_path("../tweetminer", __FILE__)

settings = YAML.load_file File.expand_path("../mongo.yml", __FILE__)
miner = TweetMiner.new(settings)

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

