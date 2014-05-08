require 'spec_helper'

describe WorkInquiry do
  it "should have required attributes" do
    [:budget, :client_email, :client_name, :client_phone, :job_description].each do |a|
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

  it { should respond_to(:reference_source) }

  describe "scopes" do
    before do
      FactoryGirl.create_list(:work_inquiry, 17)
      FactoryGirl.create_list(:work_inquiry, 24, reply: true)
    end

    it { expect(WorkInquiry.unanswered.count).to eql 17 }
    it { expect(WorkInquiry.answered.count).to eql 24 }

  end
end
