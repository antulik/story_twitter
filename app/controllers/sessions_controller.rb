class SessionsController < ApplicationController
  def create

    if params[:provider] == 'story'
      @user = User.where(:username => auth_hash.uid.to_s).first_or_initialize
      @user.save!

      auto_login(@user)

    elsif params[:provider] == 'twitter'
      if logged_in?
        current_user.twitter_key    = auth_hash['credentials']['token']
        current_user.twitter_secret = auth_hash['credentials']['secret']
        current_user.save!
      end

    end

    #self.current_user = @user
    redirect_to '/'
  end

  def destroy
    logout
    redirect_to( :root, :notice => 'Logged out!')
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end