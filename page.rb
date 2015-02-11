class Page
  include DataMapper::Resource
  include Commentable

  property :id, Serial
  property :title, String
  property :body, Text 
  property :created_at, DateTime

  has n, :comments
  has n, :likes

  belongs_to :user
  belongs_to :event
  belongs_to :group

  after :create, :add_activity

  def add_activity
     if self.event
         Activity.create(user: self.user, activity_type: 'event
         page', text: "<a href='/user/#{self.user.nickname}'>#{self.user.
         formatted_name}</a> created a page - <a href='/event/page/#{self.
         id}'>#{self.title}</a> for the event <a href='/event/#{self.event.
         id}'>#{self.event.name}</a>.")
                elsif self.group
               Activity.create(user: self.user, activity_type: 'group
         page', text: "<a href='/user/#{self.user.nickname}'>#{self.user.
         formatted_name}</a> created a page - <a href='/group/page/#{self.
         id}'>#{self.title}</a> for the group <a href='/group/#{self.group.
         id}'>#{self.group.name}</a>.")
             else
               Activity.create(user: self.user, activity_type: 'page',
         text: "<a href='/user/#{self.user.nickname}'>#{self.user.formatted_
         name}</a> created a page - <a href='/page/#{self.id}'>#{self.title}</
         a>.")
    end 
  end
end
