require 'rubygems'
require 'bundler'

Bundler.require

require './pugvine.rb'
run Pugvine

configure :production do
  require 'newrelic_rpm'
end
