class StaticPagesController < ApplicationController
  def index
    @popular_users = sort_users_by_followers
    render :layout => 'landing'
  end
end