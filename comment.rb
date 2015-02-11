class Comment
     include DataMapper::Resource
     property :id         , Serial
     property :text       , Text
     property :created_at , DateTime

     belongs_to :user
     belongs_to :page
     belongs_to :post
     belongs_to :photo
     belongs_to :activity
     belongs_to :status
end
