class Activity
     include DataMapper::Resource
     include Commentable
     property :id            , Serial
     property :activity_type , String
     property :text          , Text
     property :created_at    , DateTime

     has n, :comments
     has n, :likes

     belongs_to :user
end
