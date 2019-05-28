class CreateSnippets < ActiveRecord::Migration[5.0]
  def change
    create_table :snippets do |u|
      u.string :title
    end
  end
end
