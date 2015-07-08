OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET']
  provider :identity, fields: [:first_name, :last_name, :email, :image], 
  on_failed_registration: lambda { |env| IdentitiesController.action(:new).call(env) }
end