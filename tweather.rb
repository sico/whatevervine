require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'json'

class Tweather < Sinatra::Application

  get '/' do
    @name = fetch_tweets
    erb :index, :locals => {:name => @name}
  end

  def fetch_tweets
    content = open("http://search.twitter.com/search.json?geocode=40.660358599999995,-73.98967739999999,1km&q=weather").read
    return @parsed = JSON.parse(content)
  end

end
