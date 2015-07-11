class RemoveAvatarsFromIdentities < ActiveRecord::Migration
  def change
    remove_attachment :identities, :avatar
  end
end
