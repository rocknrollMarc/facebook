class Photo
  include DataMapper::Resource
  include Commentable

  attr_writer :tmpfile

  property :id         , Serial
  property :title      , String         , length: 255
  property :caption    , String         , length: 255
  property :privacy    , String         , default: 'public'

  property :format     , String
  property :created_at , DateTime

  belongs_to :album

  has n                , :annotations
  has n                , :comments
  has n                , :likes

  after :save          , :save_image_s3
  after :create        , :add_activity
  after :destroy       , :destroy       , :destroy_image_s3

  def filename_display; "#{id}.disp"; end
  def filename_thumbnail; "#{id}.thmb"; end

  def s3_url_thumbnail; S3.get_link(s3_bucket, filename_thumbnail, Time.now.to_i + (24*60*60)); end

  def url_thumbnail
    s3_url_thumbnail
  end

  def previous_in_album
    photos = album.photos
    index = photos.index self
    return nil unless index
    photos [index - 1] if index > 0
  end

  def next_in_album
    photos = album.photos
    index = photos.index self
    return nil unless index
    photos [index + 1] if index < album.photos.length
  end

  def save_image_s3
    return unless @tmpfile
    img = Magick::Image.from_blob(@tmpfile.open.read).first
    display = img.resize_to_fit(500, 500)
    S3.put(s3_bucket, filename_thumbnail, thumbnail.to_blob)
  end

  def destroy_image_s3
    S3.delete s3_bucket, filename_display
    S3.delete s3_bucket, filename_thumbnail
  end

  def s3_bucket
    "fc.#{album.user.id}"
  end

  def add_activity
       Activity.create(user: album.user, activity_type: 'photo',
   text: "<a href='/user/#{album.user.nickname}'>#{album.user.
   formatted_name}</a> added a new photo - <a href='/photo/#{self.
   id}'><img class='span-1' src='#{self.url_thumbnail}'/></a>")
  end

end
