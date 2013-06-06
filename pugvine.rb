require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'json'
require 'less'
require 'cgi'
require 'oauth'

class Pugvine < Sinatra::Application

  # Make LESS @import statements work
  Less.paths << settings.views

  def get_search(term, max=nil)

    baseurl = "https://api.twitter.com"
    path    = "/1.1/search/tweets.json"
    query   = URI.encode_www_form(
      "q" => "-RT+vine.co+#{term}",
      "count" => 9,
      "max_id" => max)
    address = URI("#{baseurl}#{path}?#{query}")
    request = Net::HTTP::Get.new address.request_uri

    # Set up HTTP.
    http             = Net::HTTP.new address.host, address.port
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    consumer_key = OAuth::Consumer.new ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET']
    access_token = OAuth::Token.new ENV['TWITTER_ACCESS_TOKEN'], ENV['TWITTER_ACCESS_TOKEN_SECRET']

    # Issue the request.
    request.oauth! http, consumer_key, access_token
    http.start
    response = http.request request

    # send along the body if the response was ok
    tweet = nil
    if response.code == '200' then
      return response.body
    end
  end

  get '/' do
    @thing = 'pug'
    @results = fetch_tweets('pug')
    max_tweet = @results["statuses"].min_by {|x| x["id"] }
    @max_id = max_tweet["id"].to_int + 1
    erb :index, :locals => {:results => @results, :thing => @thing, :layout => true}
  end

  get '/blank/?' do
    erb :blankpage, :layout => true
  end

  get '/look/:thing/?' do
    @results = fetch_tweets(CGI::escape(params[:thing]))
    @thing = params[:thing]
    max_tweet = @results["statuses"].min_by {|x| x["id"] }
    @max_id = max_tweet["id"].to_int + 1
    erb :index, :locals => {:results => @results}
  end

  get '/look/:thing/more/:max/?' do
    @results = fetch_tweets(CGI::escape(params[:thing]), CGI::escape(params[:max]))
    @thing = params[:thing]
    max_tweet = @results["statuses"].min_by {|x| x["id"] }
    @max_id = max_tweet["id"].to_int + 1
    erb :index, :locals => {:name => @name}
  end

  get '/pugvine.css' do
    less :pugvine
  end

  post '/find' do
    @term = params['term']
    redirect to('/look/' + CGI::escape(@term))
  end

  def fetch_tweets(term, max=1)
    content = get_search(term, max)
    return @parsed = JSON.parse(content)
  end

end
