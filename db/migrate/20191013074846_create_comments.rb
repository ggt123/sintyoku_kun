class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :topic_id
      t.string :image_id
      t.string :topic
      t.string :user_id
      t.string :user_name

      t.timestamps
    end
  end
end
