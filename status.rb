class Status
  include DataMapper::Resource
  include Commentable

  property :id         , Serial
  property :text       , String   , length: 160
  property :created_at , DateTime

  belongs_to :recipient, class_name: 'User', child_key: [:recipient_id]
  belongs_to :user
  has n, :mentions
  has n, :mentioned_users, through: :mentions, class_name: 'User', child_key: [:user_id]
  has n, :comments
  has n, :likes

  before :save do
    @mentions = []
    process
  end

  after :save do
    unless @mentions.nil?
      @mentions.each {|m|
        m.status = self
        m.save
      }
    end

    Activity.create(user: user, activity_type: 'status', text: self.text  )
  end

  # general scrubbing
  def process
    # process url
    urls = self.text.scan(URL_REGEXP)
    urls.each { |url|
      tiny_url = RestClient.get "http://tinyurl.com/api-create.php?url=#{url[0]}"
      self.text.sub!(url[0], "<a href='#{tiny_url}'>#{tiny_url}</a>")
    }
    # process @
    ats = self.text.scan(AT_REGEXP)
    ats.each { |at|
      user = User.first(nickname: at[1, at.length] )
      if user
        self.text.sub!(at, "<a href='/#{user.nickname}'>#{at}</a>")
        @mentions << Mention.new(user: user, status: self )
      end
    }
  end

  def starts_with?(prefix)
    prefix = prefix.to_s
    self.text [0, prefix.length] == prefix
  end

  def to_json(*a)
    {'id' => id, 'text'  => text, 'created_at' => created_at, 'user' => user.nickname }.to_json(*a)
  end
end
