class AddDescriptionToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :description
    end
  end
end
