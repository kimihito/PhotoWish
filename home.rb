#!/usr/bin/env ruby
#-*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra'
require './gettweet'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default,ENV['DATABASE_URL'] || 'sqlite3:db.sqlite3')

class Post
  include DataMapper::Resource
  property :id, Serial
  property :status_id, String
  property :text, String
  property :imgurl, String
  property :created_at, DateTime
  auto_upgrade!

  has n, :comments
end

class Comment
  include DataMapper::Resource
  property :id, Serial
  property :comments, Text

  belongs_to :post
  auto_upgrade!
end

get '/' do
  tweets = photowish_tweets
  tweets.each do |tweet|
    text = tweet.text
    text[/#photowish/] = ""
    text[/http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+/] = ""
    if !Post.first(:status_id => tweet.id.to_s)
     post = Post.create(
       :status_id =>tweet.id,
       :text => text,
       :imgurl => image_url(tweet),
       :created_at => Time.now
     ) 
    end
  end

  @posts = []
  Post.all.map{ |r|
    @posts << r
  }

  @posts.reverse!

  @status_id = params[:id]
  @post = Post.first(:status_id => @status_id.to_s)
  erb :index
end

get '/wish/:id' do
  @status_id = params[:id]
  @post = Post.first(:status_id => @status_id.to_s)
  
  erb :wish
end

post '/wish/:id' do
  @status_id = params[:id]
  @post = Post.first(:status_id => @status_id.to_s)
  comments = @post.comments.create(
      :comments => params[:comment]
  )
  erb :wish
end
  
get '/hoge' do
  erb :hoge
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
