class AddReferenceSourceToWorkInquiries < ActiveRecord::Migration
  def change
    add_column :work_inquiries, :reference_source, :string
  end
end
