#!/usr/bin/env ruby
#-*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra'

get '/' do
  "Hello World"
end

get '/hello/:name' do
  "Hello there,#{params[:name]}."
end

get '/test' do
  "Shotgun test"
end
