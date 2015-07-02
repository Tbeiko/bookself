class Book <ActiveRecord::Base
  has_many :user_books
  has_many :users, through: :user_books

  def add_to_user(user, status)
    self.users << user
    self.user_books.last.status = status
    self.user_books.last.save
  end
end