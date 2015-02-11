class Wall
  include DataMapper::Resource

  property :id, Serial
  has n, :posts
end
