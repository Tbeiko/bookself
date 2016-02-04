class IdentitiesController < ApplicationController
  # This is only to create fake users. Will eventually be transformed into an email sign up
  before_action :require_admin!

  def new
    @identity = ENV['omniauth.identity']
  end

  def create
    @identity = Identity.new(identity_params)
    if @identity.save
      flash[:success] = "@identity.first_name was created!"
    else
      redirect_to root_path
    end
  end

  private
    def idendity_params
      params.require(:identity).permit(:name, :first_name, :last_name, :email, :password_digest)
    end
end
