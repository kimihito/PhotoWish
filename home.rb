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
  property :text, String, length: 140
  property :imgurl, String, length: 1024
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
  tweets.reverse.each do |tweet|
    text = tweet.text
    text[/#photowish/] = "" if text[/#photowish/]
    url_regexp = /http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+/
    text[url_regexp] = "" if text[url_regexp]

    if !Post.first(:status_id => tweet.id.to_s)
      Post.create(
         status_id: tweet.id,
              text: text,
            imgurl: image_url(tweet),
        created_at: Time.now
      )
    end
  end

  @posts = Post.all.reverse
  @status_id = params[:id]
  @post = Post.first(status_id: @status_id.to_s)
  erb :index
end

get '/wish/:id' do
  @status_id = params[:id]
  @post = Post.first(status_id: @status_id.to_s)
  erb :wish
end

post '/wish/:id' do
  @status_id = params[:id]
  @post = Post.first(status_id: @status_id.to_s)
  comments = @post.comments.create(comments: params[:comment])
  erb :wish
end

get '/hoge' do
  erb :hoge
end

helpers do
  def instagram(url)
    url = url.split(/\//)[-1]
    "http://instagram.com/p/#{url}media/?size=m"
  end

  def yfrog(url)
    url = url.split(/\//)[-1]
    "http://yfrog.com/#{url}:iphone"
  end

  def twitpic(url)
    url = url.split(/\//)[-1]
    "http://twitpic.com/show/large/#{url}"
  end

  def photozo(url)
    url = url.split(/\//)[-1]
    "http://photozou.jp/p/img/#{url}"
  end

  def twipple(url)
    url = url.split(/\//)[-1]
    "http://p.twipple.jp/show/large/#{url}"
  end

  def movapic(url)
    url = url.split(/\//)[-1]
    "http://image.movapic.com/pic/m_#{url}.jpeg"
  end

  def media_check(tweet)
    tweet.urls.map{|u|
      case url = u.expanded_url
      when /http:\/\/twitpic/
        twitpic(url)
      when /http:\/\/instagr.am/
        instagram(url)
      when /http:\/\/yfrog.com/
        yfrog(url)
      when /http:\/\/photozou.jp/
        photozo(url)
      when /http:\/\/p.twipple.jp/
        twipple(url)
      when /http:\/\/movapic.com/
        # movapic(url)
      else
        ""
      end
    }
  end

  #TODO URLが二つ目だった場合の対処法
  def image_url(tweet)
    media_check(tweet).select{|u| u}.first
  end
end
