module Commentable
   def people_who_likes
     self.likes.collect { |l| "<a href='/user/#{l.user.nickname}'>#{l.
     user.formatted_name}</a>"  }
   end 
end
