require 'spec_helper'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
end

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
    let(:admin_flash) { "You must be a site admin to perform that action."}
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
      before { put :update, id: admin.id }
      it { should respond_with(200) }
    end
  end
end
