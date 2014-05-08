class CreatePostAdminRelation < ActiveRecord::Migration
  def change
    create_join_table :admins, :posts do |t|
      t.index :admin_id
      t.index :post_id
    end
  end
end
