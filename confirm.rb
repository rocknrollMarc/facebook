class Confirm
  include DataMapper::Resource

  property :id, Serial

  belongs_to :confirmed_user, class_name: 'User', child_key: [:event_id]
end
