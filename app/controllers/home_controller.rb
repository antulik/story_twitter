class HomeController < ApplicationController

  def index

  end

  def settings
    if logged_in?
      render :index
    else
      redirect_to '/auth/story'
    end
  end
end