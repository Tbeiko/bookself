Amazon::Ecs.configure do |options|
  options[:AWS_access_key_id] = ENV["AWS_access_key_id"]
  options[:AWS_secret_key] = ENV["AWS_secret_key"]
  options[:associate_tag] = "wbc0c1-20"
end