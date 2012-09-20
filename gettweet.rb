#!/usr/bin/env ruby
#-*- coding: utf-8 -*-
require "twitter"
require "uri"
Twitter.configure do |config|
  config.consumer_key = '2KMstxQcaqgMRKuPWtiLw'
  config.consumer_secret = 'Z6nRZHudkuEapsaJNfANko6oUpUJSZ3AQCAfpXwDf6s'
  config.oauth_token = '98365528-MH0n3QOoLrjb0bIihBZw8KeVAOdimAoIahxWDbiYg'
  config.oauth_token_secret = 'C7iyT5eR5TQSZbGC1QdO6oBMCTw1Jb0u67WJMIy3xmc'
end

imgurl = Twitter.search("#photowish -rt",:rpp => 1,:include_entities => 1).results.first.urls[0].expanded_url

image = ''

#TODO 画像にアクセスするURLの関数を作る

if /twitpic/ =~ imgurl
  url = imgurl.split(/\//)[-1]
  image = 'http://twitpic.com/show/large/' + url
end

p image
