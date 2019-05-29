class CreateSnippets < ActiveRecord::Migration[5.0]
  def change
    create_table :snippets do |u|
      u.string :title
      u.integer :user_id
    end
  end
end
