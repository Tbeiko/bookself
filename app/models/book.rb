class Book <ActiveRecord::Base
  has_many :user_books
  has_many :users, through: :user_books
  accepts_nested_attributes_for :user_books
  validates_presence_of :title, :authors, :amazon_link

  def add_to_user(user, status)
    self.users << user
    self.user_books.last.status = status
    self.user_books.last.save
  end

end