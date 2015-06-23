class UpdateBooks2 < ActiveRecord::Migration
  def change
    change_table(:books) { |t| t.timestamps }
  end
end
