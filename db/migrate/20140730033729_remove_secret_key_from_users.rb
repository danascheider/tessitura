class RemoveSecretKeyFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :secret_key
  end
end
