class Annotation
  include DataMapper::Resource

  property :id          , Serial
  property :description , Text
  property :x           , Integer
  property :y           , Integer
  property :height      , Integer
  property :width       , Integer
  property :created_at  , DateTime

  belongs_to :photo

  after :create, :add_activity

  def add_activity
     Activity.create(user: self.photo.album.user, activity_type: 'annotation', 
     text: "<a href='/user/#{self.photo.album.user.
     nickname}'>#{self.photo.album.user.formatted_name}</a> annotated
     a photo - <a href='/photo/#{self.photo.id}'><img class='span-1'
     src='#{self.photo.url_thumbnail}'/></a> with '#{self.description}'")
  end
end
