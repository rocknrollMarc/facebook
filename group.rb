class Group
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :description, String

  has n, :pages
  has n, :members, class_name: 'User', through: Resource
  belongs_to :wall

  after :create, :create_wall

  def create_wall
    self.wall = Wall.create
    self.save
  end

  after :create, :add_activity

  def add_activity
      Activity.create(user: self.user, activity_type: 'event',
       text: "<a href='/user/#{self.user.nickname}'>#{self.user.formatted_name}</a> created a new group - <a href='/group/#{self.id}'>#{self.name}</a>.")
  end
end
