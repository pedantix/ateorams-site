require 'spec_helper'

describe Admin do

  describe "should have attributes" do
    let(:admin) { Admin.new }
    it { expect(admin).to respond_to(:name) }
    it { expect(admin).to respond_to(:email) }
    it { expect(admin).to respond_to(:password) }
    it { expect(admin).to respond_to(:password_confirmation) }
    it { expect(admin).to respond_to(:phone) }
    it { expect(admin).to respond_to(:twitter_handle) }
    it { expect(admin).to respond_to(:approved) }
    it { expect(admin).to respond_to(:site_admin) }
  end  


  it "should validate presence of required attributes" do
    [:name, :email].each {|a| should validate_presence_of(a) }
  end


  describe ":approved?" do
    it { expect(FactoryGirl.create(:admin).approved?).to_not be_true }
    it { expect(FactoryGirl.create(:approved_admin).approved?).to be_true }
  end
end
