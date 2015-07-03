# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create Users
10.times do |user, n|
  user            = User.new
  user.first_name = Faker::Name.first_name
  user.last_name  = Faker::Name.last_name
  user.email      = Faker::Internet.email
  user.image      = "https://randomuser.me/api/portraits/men/36.jpg"
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

  # Add read books to the user
  5.times do |n|
    book = Book.find(n+1)
    book.users << user
    book.user_books.last.update_attributes!(status: "read")
    book.user_books.last.save
    n += 1
  end
  # Add to-read books to the user
  5.times do |n|
    book = Book.find(n+9)
    book.users << user
    book.user_books.last.update_attributes!(status: "to-read")
    book.user_books.last.save
    n += 1
  end

end

 


