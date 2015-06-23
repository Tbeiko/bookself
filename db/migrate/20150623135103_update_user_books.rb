class UpdateUserBooks < ActiveRecord::Migration
  def change
    add_column :user_books, :status, :string
  end
end
