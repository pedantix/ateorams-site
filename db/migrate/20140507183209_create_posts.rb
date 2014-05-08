class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :body
      t.string :title
      t.string :slug

      t.timestamps
    end

    add_index :posts, :slug, unique: true
  end
end
