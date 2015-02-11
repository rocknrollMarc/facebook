 class User
     include DataMapper::Resource
     property :id                  , Serial
     property :email               , String , length: 255
     property :nickname            , String , length: 255
     property :formatted_name      , String , length: 255
     property :sex                 , String , length: 6
     property :relationship_status , String
     property :provider            , String , length: 255
     property :identifier          , String , length: 255
     property :photo_url           , String , length: 255
     property :location            , String , length: 255
     property :description         , String , length: 255
     property :interests           , Text
     property :education           , Text

     has n                         , :relationships
     has n                         , :followers                       , through: :relationships , class_name: 'User'                          , child_key: [:user_id]
     has n                         , :follows                         , through: :relationships , class_name: 'User' ,
   remote_name: :user              , child_key: [:follower_id]
     has n                         , :statuses
     belongs_to :wall
     has n                         , :groups                          , through: Resource
     has n                         , :sent_messages                   , class_name: 'Message'   , child_key:
   [:user_id]
     has n                         , :received_messages               , class_name: 'Message'   , child_key:
   [:recipient_id]
     has n                         , :confirms
     has n                         , :confirmed_events                , through: :confirms      , class_name:
   'Event'                         , child_key: [:user_id]            , :date.gte => Date.today
     has n                         , :pendings
     has n                         , :pending_events                  , through: :pendings      , class_name:
   'Event'                         , child_key: [:user_id]            , :date.gte => Date.today
     has n                         , :requests
     has n                         , :albums
     has n                         , :photos                          , through: :albums
     has n                         , :comments
     has n                         , :activities
     has n                         , :pages
     validates_is_unique :nickname , message: "Someone else has taken
   up this nickname                , try something else!"
     after :create                 , :create_s3_bucket
     after :create                 , :create_wall

    def add_friend(user)
      Relationship.create(user: user, follower: self)
    end

    def friends
      (followers + follows).uniq
    end

    def self.find(identifier)
      u = first(identifier: identifier)
      u = new(identifier: identifier) if u.nil?
      return u
    end

    def feed
      feed = [] + activities
      friends.each do |friend|
        feed += friend.activities
      end

      return feed.sort { |x,y| y.created_at <=> x.created_at}
    end

    def possessive_pronoun
      sex.downcase == 'male' ? 'his' : 'her'
    end

    def pronoun
      sex.downcase == 'male' ? 'he' : 'she'
    end

    def create_s3_bucket
      S3.create_bucket("fc.#{id}")
    end

    def create_wall
      self.wall = Wall.create
      self.save
    end

    def all_events
      confirmed_events + pending_events
    end

    def friend_events
     events = []
     friends.each do |friend|
       events += friend.confirmed_events
     end
     return events.sort {|x,y| y.time <=> x.time}
   end

    def friend_groups
      groups = []
      friends.each do |friend|
        groups += friend.groups
      end
      groups - self.groups
    end


 end
