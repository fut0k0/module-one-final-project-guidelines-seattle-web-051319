class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |u|
      u.string :name
      u.integer :song_id
      u.integer :snippet_id
    end
  end
end
