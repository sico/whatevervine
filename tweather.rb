require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'json'

class Tweather < Sinatra::Application

  get '/' do
    @name = fetch_tweets
    @snows = check_snow(@name)
    erb :index, :locals => {:name => @name, :snows => @snows}
  end

  def fetch_tweets
    content = open("http://search.twitter.com/search.json?geocode=40.660358599999995,-73.98967739999999,5mi&q=snow&rpp=100&result_type=recent").read
    return @parsed = JSON.parse(content)
  end

  def check_snow(tweets)
    s = 0
    tweets['results'].each do |tweet|
      if tweet['text'].include? "brooklyn"
        s += 1
      end
    end
    return s
  end

end
