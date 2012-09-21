#!/usr/bin/env ruby
#-*- coding: utf-8 -*-
require "twitter"

Twitter.configure do |config|
  config.consumer_key = '2KMstxQcaqgMRKuPWtiLw'
  config.consumer_secret = 'Z6nRZHudkuEapsaJNfANko6oUpUJSZ3AQCAfpXwDf6s'
  config.oauth_token = '98365528-MH0n3QOoLrjb0bIihBZw8KeVAOdimAoIahxWDbiYg'
  config.oauth_token_secret = 'C7iyT5eR5TQSZbGC1QdO6oBMCTw1Jb0u67WJMIy3xmc'
end

def hashtag_tweet(hashtag)
  Twitter.search("#"+hashtag+" -rt",:rpp => 100,:include_entities => 1).results
end

def photowish_tweets
  hashtag_tweet("photowish").select{|tweet| expanded_url?(tweet)}
end

def expanded_url(tweet)
  tweet.urls.select{|u| u.expanded_url}.map{|u| u.expanded_url}
end

def expanded_url?(tweet)
  #ツイートに添付されたすべてのURLの中に,expanded_urlが1つでも含まれていればtrue
  expanded_url(tweet).count != 0
end





#TODO 画像にアクセスするURLの関数を作る
def getimg(hashtag)
  imgurl = ''
  images = []
  texts = []
  Twitter.search("#"+hashtag+" -rt",:rpp => 100,:include_entities => 1).results.each do |result|
    begin
      texts << result.text
      imgurl = isexpanded(result)
      if /twitpic/ =~ imgurl
        url = imgurl.split(/\//)[-1]
        images << 'http://twitpic.com/show/large/' + url
      end
    rescue
    end
  end
  images
end

#expanded_urlがあるかどうかを確認する関数
def isexpanded(result)
  if result.urls[0].expanded_url == nil
    nil
  else
    result.urls[0].expanded_url
  end
end

#TODO 他の画像投稿サービスを使ってimgを取得する。  
puts getimg("photowish")

