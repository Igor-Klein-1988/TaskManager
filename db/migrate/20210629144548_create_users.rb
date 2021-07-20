class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :password_digest, null: false
      t.string :email, null: false, unique: true
      t.string :avatar
      t.string :type

      t.timestamps
    end
  end
end
