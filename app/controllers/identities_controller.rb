class IdentitiesController < ApplicationController
  def new
    @identity = env['omniauth.identity']
  end

  def create
    @identity = Identity.new(identity_params)
    if @identity.save!
    else
      redirect_to :back
      flash[:danger] = "Something went wrong"
    end
  end

  private
    def idendity_params
      params.require(:identity).permit(:name, :first_name, :last_name, :image, :email, :password_digest)
    end
end
