class AddAttachmentAvatarToIdentities < ActiveRecord::Migration
  def self.up
    change_table :identities do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :identities, :avatar
  end
end
