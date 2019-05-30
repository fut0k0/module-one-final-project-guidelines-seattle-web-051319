class UpdateSnippets2 < ActiveRecord::Migration[5.0]
  def change
    remove_column :snippets, :lyric
    add_column(:snippets, :lyric, :string)
  end
end
