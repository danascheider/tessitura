class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.date :birthdate
      t.string :fach
      t.string :city
      t.string :country
      t.boolean :admin
      t.timestamps
    end
  end
end
