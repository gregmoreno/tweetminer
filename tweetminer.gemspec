# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tweetminer/version"

Gem::Specification.new do |s|
  s.name        = "tweetminer"
  s.version     = TweetMiner::VERSION
  s.authors     = ["Greg Moreno"]
  s.email       = ["greg.moreno@gmail.com"]
  s.homepage    = ""
  s.summary     = "Mining Twitter data using Ruby"

  s.rubyforge_project = "tweetminer"

  s.files         = `git ls-files`.split("\n")
#  s.files         << "Gemfile Gemfile.lock LICENSE README tweetminer.gemspec"
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "mongo"
  s.add_dependency "bson_ext"
end
