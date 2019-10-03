class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :session_id
      t.string :user_id
      t.string :have_account
      t.string :email
      t.string :password
      t.string :name

      t.timestamps
    end
  end
end
