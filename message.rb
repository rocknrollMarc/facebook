class Message
  include DataMapper::Resource

  property :id         , Serial
  property :subject    , String
  property :text       , Text
  property :created_at , DateTime
  property :read       , Boolean  , default:  false
  property :thread     , Integer

  belongs_to :sender, class_name: 'User', child_key: [:user_id]
  belongs_to :recipient, class_name: 'User', child_key: [:recipient_id]
end
