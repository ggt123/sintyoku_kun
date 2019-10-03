class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.string :image_id
      t.text :title
      t.text :title_topic
      t.string :user_id

      t.timestamps
    end
  end
end
