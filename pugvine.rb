require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'json'
require 'less'
require 'cgi'

class Pugvine < Sinatra::Application

  # Make LESS @import statements work
  Less.paths << settings.views

  get '/' do
    @thing = 'pug'
    @page = 1
    @name = fetch_tweets('pug')
    erb :index, :locals => {:name => @name, :thing => @thing, :page => @page}, :layout => true
  end

  get '/blank/?' do
    erb :blankpage, :layout => true
  end

  get '/look/:thing/?' do
    @page = 1
    @thing = params[:thing]
    @name = fetch_tweets(CGI::escape(params[:thing]))
    erb :index, :locals => {:name => @name, :page => @page}
  end

  get '/look/:thing/:page/?' do
    @page = params[:page].to_i
    @thing = params[:thing]
    @name = fetch_tweets(CGI::escape(params[:thing]), params[:page])
    erb :index, :locals => {:name => @name, :page => @page}
  end

  get '/pugvine.css' do
    less :pugvine
  end

  post '/find' do
    @term = params['term']
    redirect to('/look/' + CGI::escape(@term))
  end

  def fetch_tweets(term, page=1)
    content = open("http://search.twitter.com/search.json?q=vine.co%20#{term}&rpp=9&page=#{page}&result_type=recent&include_entities=true").read
    return @parsed = JSON.parse(content)
  end

end
