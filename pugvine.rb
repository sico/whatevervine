require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'json'
require 'less'

class Pugvine < Sinatra::Application

  get '/' do
    @name = fetch_tweets('pug')
    erb :index, :locals => {:name => @name}
  end

  get '/look/:thing' do
    @name = fetch_tweets(params[:thing])
    erb :index, :locals => {:name => @name}
  end

  get '/corgis' do
    @name = fetch_tweets('corgi')
    erb :index, :locals => {:name => @name}
  end

  get '/pugvine.css' do
    less :pugvine
  end

  def fetch_tweets(term)
    content = open("http://search.twitter.com/search.json?q=vine.co%20#{term}&rpp=9&result_type=recent&include_entities=true").read
    return @parsed = JSON.parse(content)
  end

end
