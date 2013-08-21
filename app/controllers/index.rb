get '/' do
  @access_token = session[:access_token]
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  
    @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    
    session.delete(:request_token)
    # our request token is only valid until we use it to get an access token, so let's delete it from our session
   
    @user = User.find_or_create_by_username(username: @access_token.params[:screen_name], oauth_token: @access_token.token, oauth_secret: @access_token.secret)
     
    session[:user_id] = @user.id
    session[:access_token] = @access_token
    # end
 
  # at this point in the code is where you'll need to create your user account and store the access token

  redirect '/'
  
end

get '/status/:job_id' do
  puts job_is_complete(params[:job_id])
  job_is_complete(params[:job_id]).to_s
end

post '/' do
  puts "------------------------------------"
  # twitter_client.update(params[:tweet])
  @user = User.find_by_id(session[:user_id])
  @user.tweet(params[:tweet])
end
