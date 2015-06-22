class CreateAssociations < ActiveRecord::Migration
  def change
    create_table :users_books do |t|
      t.integer :user_id, :book_id
    end
  end
end
