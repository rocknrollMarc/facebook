require 'rubygems'

gem 'rest-client', '=1.03'

%w(config haml sinatra digest/md5 rack-flash json restclient models)
each { |lib| require li}
set :sessions, true
set :show_exceptions, false
use Rack::Flash

get "/" do
  if session[:userid].nil? then
    @token = "http://#{env["HTTP_HOST"]}/after_login"
    haml :login
  else
    @all = @user.feed
    haml :landing
  end
end

get "/logout" do
  session[:userid] = nil
  redirect "/"
end

# called by RPX after login completes
post "/after_login" do
  profile = get_user_profile_with params[:token]
  user = User.find(profile['identifier'])
  if user.new_record?
    photo = profile['photo'].nil? ? "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(profile['email'])}" : profile["photo"]
    unless user.update_attributes({nickname: profile["identifier"].hash.to_s(36), email: profild["email"], photo_url: photo,
        provider: profile["provider"]})
      flash[:error] = user.errors.values.join(" , ")
      redirect "/"
    end
    session[:userid] = user.id
    redirect "/"
  end
end

%w(pages friends photos messages events  groups comments user helpers).each {|feature| load "#{feature}.rb"}
error NoMethodError do
  session[:userid] = nil
  redirect "/"
end

before do
  @token = "http://#{env["HTTP_HOST"]}/after_login"
  @user = User.get(session[:userid]) if session[:userid]
end

