require 'rubygems'
require 'bundler'

Bundler.require

require './pugvine.rb'
run Pugvine

configure :production do
  require 'newrelic_rpm'
end

configure :development do
  #show stdout in console
  $stdout.sync = true
end
