class RenameUsersBooks < ActiveRecord::Migration
  def change
    rename_table :users_books, :user_books
  end
end
