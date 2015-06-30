# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create Users
100.times do |user, n|
  user            = User.new
  user.first_name = Faker::Name.first_name
  user.last_name  = Faker::Name.last_name
  user.email      = Faker::Internet.email
  user.image      = "https://randomuser.me/api/portraits/men/37.jpg"
  user.created_at = Time.zone.now
  user.save!

  # Have the users follow all previous users
  n=1
  until n > User.all.count
    User.all.each do |u|
      unless n == user.id
        user.follow(u)
      end
      n += 1
    end
  end

  # Add books to the user.
  5.times do 
    user.books << Book.first 
    user.books << Book.last
  end

end

 


