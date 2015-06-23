class UpdateBooks < ActiveRecord::Migration
  def change
    remove_column :books, :publication_date
    rename_column :books, :isbn, :amazon_link
    rename_column :books, :isbn_10, :asin
    remove_column :books, :description
  end
end
