#!/usr/bin/env ruby
#-*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra'
require './gettweet'

get '/' do
  @tweets = photowish_tweets
  erb :index
end

helpers do
  def instagram(url)
    #do something
  end

  def twitpic(url)
    imgurl = ''
    url = url.split(/\//)[-1]
    imgurl = 'http://twitpic.com/show/large/' + url
  end

  def media_check(tweet)
    tweet.urls.map{|u| 
      case url = u.expanded_url
      when /http:\/\/twitpic/
        twitpic(url)
      when /http:\/\/instagr.am/
        instagram(url)
      else
        nil
      end
    }  
  end


  #TODO URLが二つ目だった場合の対処法
  def image_url(tweet)
    media_check(tweet).select{|u| u}.first
  end
end



