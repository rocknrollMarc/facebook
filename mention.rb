class Mention
  include DataMapper::Resource

  property :id , Serial

  belongs_to :user
  belongs_to :status
end
