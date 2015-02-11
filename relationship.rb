class Relationship
  include DataMapper::Resource

  property   :user_id     , Integer               , key: true
  property   :follower_id , Integer               , key: true
  belongs_to :user        , child_key: [:user_id]
  belongs_to :follower    , class_name: 'User'    , child_key: [ :follower_id]
  after      :save        , :add_activity

  def add_activity
    Activity.create(user: user, activity_type: 'relationship', 
    text: "<a href='/user/#{user.nickname}'>#{user.formatted_name}</a>
    and <a href='/user/#{follower.nickname}'>#{follower.formatted_name}</a> 
    are now friends.")
  end
end
