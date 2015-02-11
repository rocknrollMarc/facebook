class Request
  include DataMapper::Resource

  property :id         , Serial
  property :text       , Text
  property :created_at , DateTime

  belongs_to :from, class_name: User, child_key: [:from_id]
  belongs_to :user

  def approve
    self.user.add_friend(self.from)
  end
end
