class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :authors
      t.string :publication_date
      t.string :isbn
      t.string :isbn_10
      t.string :description
      t.string :cover_image_link
    end
  end
end
