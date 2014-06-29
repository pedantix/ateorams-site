class AddGoalsToWorkInquires < ActiveRecord::Migration
  def change

    add_column :work_inquiries, :goals, :text
  end
end
