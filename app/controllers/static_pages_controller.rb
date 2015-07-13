class StaticPagesController < ApplicationController
  before_action :sort_users_by_followers, only: :index
  def index
    render :layout => 'landing'
  end
end