class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |u|
      u.string :name
    end
  end
end
