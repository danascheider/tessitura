class AddLoggedInAndIsAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :logged_in, :boolean
    add_column :users, :is_admin, :boolean
  end
end
