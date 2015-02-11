class Album
  include DataMapper::Resource

  property :id          , Serial
  property :name        , String   , length: 255
  property :description , Text
  property :created_at  , DateTime

  belongs_to :user
  has n, :photos
  belongs_to :cover_photo, class_name: 'Photo', child_key: [:cover_photo_id]

  after :save, :add_activity

  def add_activity
    Activity.create(user: user, activity_type: 'album', text:
    "<a href='/user/#{user.nickname}'>#{user.formatted_name}</a> 
    created a new album <a hef='/album/#{self.id}'>#{self.name}</a>")
  end
end
