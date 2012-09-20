#!/usr/bin/env ruby
#-*- coding: utf-8 -*-
require "twitter"
Twitter.configure do |config|
  config.consumer_key = '2KMstxQcaqgMRKuPWtiLw'
  config.consumer_secret = 'Z6nRZHudkuEapsaJNfANko6oUpUJSZ3AQCAfpXwDf6s'
  config.oauth_token = '98365528-MH0n3QOoLrjb0bIihBZw8KeVAOdimAoIahxWDbiYg'
  config.oauth_token_secret = 'C7iyT5eR5TQSZbGC1QdO6oBMCTw1Jb0u67WJMIy3xmc'
end

#TODO 画像にアクセスするURLの関数を作る

def getimg(hashtag)
  imgurl = ''
  imgurl = Twitter.search("#"+hashtag+" -rt",:rpp => 1,:include_entities => 1).results.first.urls[0].expanded_url

  if /twitpic/ =~ imgurl
    url = imgurl.split(/\//)[-1]
    image = 'http://twitpic.com/show/large/' + url
  end
  #TODO 他の画像投稿サービスを使ってimgを取得する。  
  if 
  end

  return image
end

p getimg("photowish")
