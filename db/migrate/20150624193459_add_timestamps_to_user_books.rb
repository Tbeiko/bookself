class AddTimestampsToUserBooks < ActiveRecord::Migration
  def change
    change_table(:user_books) { |t| t.timestamps }
  end
end
