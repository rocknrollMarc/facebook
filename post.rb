 class Post
     include DataMapper::Resource
     include Commentable
     property :id, Serial
     property :text, Text
     property :created_at, DateTime
     belongs_to :user
     belongs_to :wall
     has n, :comments
     has n, :likes
end
