#!/usr/bin/env ruby
#-*- coding: utf-8 -*-
require './gettweet'
require 'erb'

a = 1
b = 2
c = 3

template = ERB.new <<-EOF
  a = <%= a %>
  b = <%= b %>
  c = <%= c %>
EOF

puts template.result(binding)
puts getimg("photowish")
