require 'spec_helper'



describe AdminUsersController do
  let(:admin) {FactoryGirl.create(:admin) }
  let(:approved) { FactoryGirl.create(:approved_admin) }
  let(:site_admin) { FactoryGirl.create(:site_admin)}

  describe "routing" do
     it { expect(subject).to route(:get, '/admin_users').to(controller: 'admin_users', action: :index) }
     it { expect(subject).to route(:patch, "/admin_users/#{admin.id}").to(controller: 'admin_users', action: :update, id: admin.id) }
     it { expect(subject).to route(:get, "/admin_users/#{admin.id}/edit").to(controller: 'admin_users', action: :edit, id: admin.id) }
  end

  context "logged out, should redirect all to root path" do    
    describe "index" do
      before { get :index }
      it { should redirect_to(root_path)}
      it { should set_the_flash.to("You must be signed in to perform that action.")}
    end

    describe "edit" do
      before { get :edit, id: admin.id }
      it { should redirect_to(root_path)}
      it { should set_the_flash.to("You must be signed in to perform that action.")}
    end


    describe "update" do
      before { put :update, id: admin.id }
      it { should redirect_to(root_path)}
      it { should set_the_flash.to("You must be signed in to perform that action.")}
    end
  end


  context "logged in as an admin that is not a site admin, should redirect all to root path" do    
    let(:admin_flash) { "You must be a site admin to perform that action."}
    before { sign_in approved }


    describe "index" do
      before { get :index }
      it { should redirect_to(root_path)}
      it { should set_the_flash.to(admin_flash) }
    end

    describe "edit" do
      before { get :edit, id: admin.id }
      it { should redirect_to(root_path)}
      it { should set_the_flash.to(admin_flash) }
    end


    describe "update" do
      before { put :update, id: admin.id }
      it { should redirect_to(root_path)}
      it { should set_the_flash.to(admin_flash) }
    end
  end

  context "logged in as a site admin, should respond with 200" do    
    before { sign_in site_admin }

    describe "index" do
      before { get :index }
      it { should respond_with(200) }
    end

    describe "edit" do
      before { get :edit, id: admin.id }
      it { should respond_with(200) }
    end

    describe "update" do
      it "should change the count of approved admins " do
        expect do
          put :update, id: admin.id, admin: { approved: true }
        end.to change(Admin.approved_admins, :count).by(1)
      
        should set_the_flash.to("User privileges updated successfully.")
        should redirect_to(admin_users_path)
      end

      it "should change the count of site admins " do
        expect do
          put :update, id: admin.id, admin: { approved: true, site_admin: true }
        end.to change(Admin.site_admins, :count).by(1)
      
        should set_the_flash.to("User privileges updated successfully.")
        should redirect_to(admin_users_path)
      end
    end
  end
end
