class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :first_name
      t.string :last_name
      t.string :image
      t.string :email
      t.string :password_digest
      t.timestamps null: false
    end
  end
end
