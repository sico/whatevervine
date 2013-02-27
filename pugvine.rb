require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'json'
require 'less'

class Pugvine < Sinatra::Application

  get '/' do
    @name = fetch_tweets
    erb :index, :locals => {:name => @name}
  end

  get '/pugvine.css' do
    less :pugvine
  end

  def fetch_tweets
    content = open("http://search.twitter.com/search.json?q=vine.co%20pug&rpp=9&result_type=recent&include_entities=true").read
    return @parsed = JSON.parse(content)
  end

end
