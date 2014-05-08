class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :title
      t.string :slug

      t.timestamps
    
      t.index :slug, unique: true

    end
 
    create_join_table :posts, :tags do |t|
      t.index :post_id
      t.index :tag_id
      t.index [:post_id, :tag_id], unique: true 
    end
  end
end
