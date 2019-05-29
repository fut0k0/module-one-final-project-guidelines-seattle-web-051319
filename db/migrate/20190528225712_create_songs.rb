class CreateSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |u|
      u.string :artist
      u.string :title
      u.text :lyrics
      u.integer :user_id
    end
  end
end
