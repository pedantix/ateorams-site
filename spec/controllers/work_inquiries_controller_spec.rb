require 'spec_helper'

describe WorkInquiriesController do
  let(:work_inquiry) {FactoryGirl.create(:work_inquiry) }
  let(:approved) { FactoryGirl.create(:approved_admin) }
  let(:site_admin) { FactoryGirl.create(:site_admin)}

  describe "routing" do
     it { expect(subject).to route(:get, '/work_inquiries').to(controller: 'work_inquiries', action: :index) }
     it { expect(subject).to route(:patch, "/work_inquiries/#{work_inquiry.id}").to(controller: 'work_inquiries', action: :update, id: work_inquiry.id) }
     it { expect(subject).to route(:get, "/work_inquiries/#{work_inquiry.id}/edit").to(controller: 'work_inquiries', action: :edit, id: work_inquiry.id) }
     it { expect(subject).to route(:get, "/work_inquiries/#{work_inquiry.id}").to(controller: 'work_inquiries', action: :show, id: work_inquiry.id)}
  end

  context "logged out, should redirect all to root path" do    
    
    describe "index" do
      before { get :index }
      it { should redirect_to(root_path)}
      it { should set_the_flash.to("You must be signed in to perform that action.")}
    end

    describe "edit" do
      before { get :edit, id: work_inquiry.id }
      it { should redirect_to(root_path)}
      it { should set_the_flash.to("You must be signed in to perform that action.")}
    end

    describe "show" do
      before { get :show, id: work_inquiry.id }
      it { should redirect_to(root_path)}
      it { should set_the_flash.to("You must be signed in to perform that action.")}
    end


    describe "update" do
      before { put :update, id: work_inquiry.id }
      it { should redirect_to(root_path)}
      it { should set_the_flash.to("You must be signed in to perform that action.")}
    end


  end


  context "logged in as an approved admin" do
    before { sign_in site_admin }
    
    describe "index" do
      before { get :index }
      it { should respond_with(200) }
      it { should_not set_the_flash.to("You must be signed in to perform that action.")}
    end

    describe "edit" do
      before { get :edit, id: work_inquiry.id }
      it { should respond_with(200) }
      it { should_not set_the_flash.to("You must be signed in to perform that action.")}
    end

    describe "show" do
      before { get :show, id: work_inquiry.id }
      it { should respond_with(200) }
      it { should_not set_the_flash.to("You must be signed in to perform that action.")}
    end

    describe "update" do
      it "should change the numbder of answered work_inquiries" do 
        work_inquiry
        expect do
          put :update, id: work_inquiry.id, work_inquiry: {reply: true}
        end.to change(WorkInquiry.answered, :count).by(1)

        should redirect_to( work_inquiry_path(work_inquiry)) 
        should set_the_flash.to("Successfully updated status of work inquiry.")
      end
    end
  end
end
