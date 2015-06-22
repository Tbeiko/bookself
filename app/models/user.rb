class User <ActiveRecord::Base
  has_many :userbooks
  has_many :books, through: :user_books
end