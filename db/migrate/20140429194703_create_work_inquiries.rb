class CreateWorkInquiries < ActiveRecord::Migration
  def change
    create_table :work_inquiries do |t|
      t.string :client_name
      t.string :client_email
      t.string :client_phone
      t.text :job_description
      t.string :budget
      t.boolean :reply, default: false

      t.timestamps
    end
  end
end
