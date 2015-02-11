class Event
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :description, String
  property :venue, String
  property :date, DateTime
  property :time, Time

  belongs_to :user
  has n, :pages
  has n, :confirms
  has n, :confirmed_users, through: :confirms, class_name:
   'User', child_key: [:event_id], mutable: true
     has n, :pendings
     has n, :pending_users, through: :pendings, class_name: 'User',
   child_key: [:event_id], mutable: true
     has n, :declines
     has n, :declined_users, through: :declines, class_name:
   'User', child_key: [:event_id], mutable: true
     belongs_to :wall

     after :create, :create_wall

     def create_wall
       self.wall = Wall.create
     end

     after :create, :add_activity

     def add_activity
       Activity.create(user: self.user, activity_type: 'event',
       text: "<a href='/user/#{self.user.nickname}'>#{self.user.formatted_
       name}</a> created a new event - <a href='/event/#{self.id}'>#{self.
       name}</a>.")
    end
end
