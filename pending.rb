class Pending
  include DataMapper::Resource

  property :id, Serial

  belongs_to :pending_user, class_name: 'User', child_key: [:user_id]
  belongs_to :pending_event, class_name: 'Event', child_key: [:event_id]
end
