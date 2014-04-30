require 'spec_helper'

describe WorkInquiry do
  it "should have required attributes" do
    [:budget, :client_email, :client_name, :client_phone].each do |a|
      should validate_presence_of(a)
    end
  end

  it "#reply, should default to false" do
    expect(FactoryGirl.create(:work_inquiry).reply).to eql false
  end

  it "#client_email, should require the email to be valid per patern" do
    expect(FactoryGirl.build(:work_inquiry, client_email:"bad3mail.com")).to be_invalid
    expect(FactoryGirl.build(:work_inquiry, client_email:"good@mail.com")).to be_valid
  end
end
