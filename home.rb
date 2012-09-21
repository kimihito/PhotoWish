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

  def twipic(url)
    imgurl = ''
    url = url.split(/\//)[-1]
    imgurl = 'http://twitpic.com/show/large/' + url
  end

  def image_url(tweet)
    url = expanded_url(tweet).first
    case url
    when /http:\/\/twitpic/
      twipic(url)
    when /http:\/\/instagr.am/
      instagram(url)
    else
      url #none
    end
  end
end



