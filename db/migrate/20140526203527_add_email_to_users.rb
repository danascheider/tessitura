class AddEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string, after: :name
  end
end
