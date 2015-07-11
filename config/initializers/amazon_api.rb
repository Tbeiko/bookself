Amazon::Ecs.configure do |options|
  options[:AWS_access_key_id] = ENV["AWS_ACCESS_KEY_ID"]
  options[:AWS_secret_key] = ENV["AWS_SECRET_KEY"]
  options[:associate_tag] = ENV["associate_tag"]
  options[:version] = "2013-08-01"
end