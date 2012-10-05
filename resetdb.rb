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

Post.all.each(&:destroy)
Comment.all.each(&:destroy)
