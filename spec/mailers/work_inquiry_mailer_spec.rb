require "spec_helper"


describe WorkInquiryMailer do
  #after { if example.exception then binding.pry end }
  describe "#confirmation" do
    let(:inquiry) { FactoryGirl.create(:work_inquiry) }
    let(:email) { WorkInquiryMailer.confirmation(inquiry) }
    let(:statement_of_purpose) do
      %Q|Every project is important to us. We sent you this email to confirm that our web app is notifying the team of your interest. The details of your request are as follows:|
    end
    it_behaves_like "multipart email"
   
    it { expect(email.subject).to eql("Request Received. Thank you, for your interest!") }
    it { expect(email.to).to include( inquiry.client_email )}
    it { expect(email.from).to include( "no-reply@ateorams.com" )}
    pending "email_bcc, to site admins"

    shared_examples_for "email content" do
       after(:each) { output_page_error example, part }

      it "should be sent to the client" do
        expect(part).to include("#{inquiry.client_name},")
      end

      it "should include a statement of purpose" do
        expect(part).to include statement_of_purpose
      end

      it "should include details of project" do
        expect(part).to include("Project Description")
        expect(part).to include(inquiry.job_description)
        expect(part).to include("Contact Information")
        expect(part).to include("Name")
        expect(part).to include(inquiry.client_name)
        expect(part).to include("Email")
        expect(part).to include(inquiry.client_email)
        expect(part).to include("Phone Number")
        expect(part).to include(inquiry.client_phone)
        expect(part).to include("Project Budget")
        expect(part).to include(inquiry.budget)
      end
 
      it "should have signature block" do
        expect(part).to match("A team member will follow up with you regarding your inquiry shortly. Thank you for your interest in us to produce your application.")
        expect(part).to match("Shaun Hubbard")
        expect(part).to match("ATEORAMS Developer")
      end
    end

    
    context "plain text" do
      let(:part) { get_email_part(email, /plain/)}
      it { expect(part)}
      it_behaves_like "email content"
    end

    context "html" do
      let(:part) { get_email_part(email, /html/)}
    
      it_behaves_like "email content"
    end
  end
end
