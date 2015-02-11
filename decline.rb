class Decline
  include DataMapper::Resource

  property :id, Serial

  belongs_to :declined_user, class_name: 'Event', child_key: [:event_id]
end
