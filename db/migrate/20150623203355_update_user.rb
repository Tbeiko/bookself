class UpdateUser < ActiveRecord::Migration
  def change
    remove_column :users, :expires_at
    add_column :users, :expires_at, :datetime
    change_table(:users) { |t| t.timestamps }
  end
end
