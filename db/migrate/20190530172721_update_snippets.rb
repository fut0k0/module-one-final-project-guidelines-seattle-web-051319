class UpdateSnippets < ActiveRecord::Migration[5.0]
  def change
    add_column(:snippets, :lyric, :text)
    remove_column :snippets, :title
  end
end
