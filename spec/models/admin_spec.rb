require 'spec_helper'

describe Admin do

  describe "should have attributes" do
    let(:admin) { Admin.new }
    it { expect(admin).to respond_to(:username) }
    it { expect(admin).to respond_to(:email) }
    it { expect(admin).to respond_to(:password) }
    it { expect(admin).to respond_to(:password_confirmation) }
    it { expect(admin).to respond_to(:phone) }
    it { expect(admin).to respond_to(:twitter_handle) }
    it { expect(admin).to respond_to(:approved) }
    it { expect(admin).to respond_to(:site_admin) }
  end  


  it "should validate presence of required attributes" do
    [:username, :email].each {|a| should validate_presence_of(a) }
  end


  describe ":approved?" do
    it { expect(FactoryGirl.create(:admin).approved?).to_not be_true }
    it { expect(FactoryGirl.create(:approved_admin).approved?).to be_true }
  end


  describe "admin scopes"  do
    let(:unapproved_admins) { FactoryGirl.create_list(:admin, 9) }
    let(:approved_admins) { FactoryGirl.create_list(:approved_admin, 10) }
    let(:site_admins) { FactoryGirl.create_list(:site_admin, 11) }


    before { unapproved_admins; approved_admins; site_admins; } # approved_admins; site_admins; }

    it { expect(Admin.unapproved_admins.count).to eql 9 }
    it { expect(Admin.approved_admins.count).to eql 10 }
    it { expect(Admin.site_admins.count).to eql 11 }

  end

end
