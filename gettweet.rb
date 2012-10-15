#!/usr/bin/env ruby
#-*- coding: utf-8 -*-
require "twitter"
for github
Twitter.configure do |config|
  config.consumer_key = 'YOUR_CONSUMER_KEY'
  config.consumer_secret = 'YOUR_CONSUMER_SECRET'
  config.oauth_token = 'YOUR_OAUTH_TOKEN'
  config.oauth_token_secret = 'YOUR_OAUTH_TOKEN_SECRET'
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
