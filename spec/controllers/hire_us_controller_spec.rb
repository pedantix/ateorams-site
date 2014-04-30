require 'spec_helper'

describe HireUsController do

  describe "routing" do
     it { expect(subject).to route(:get, '/hire_us').to(controller: 'hire_us', action: :show) }
     it { expect(subject).to route(:post, '/hire_us').to(controller: 'hire_us', action: :create) }
     it { expect(subject).to route(:get, '/hire_us/confirmation').to(controller: 'hire_us', action: :confirmation) }
  end

  describe "#show, aliasing new" do
    it "should be valid" do
      get :show
      expect(response).to be_success
    end
  end



  describe "#create" do
    let(:valid_inquiry) do
      {
        client_name: Faker::Name.name,
        client_email:  Faker::Internet.email,
        client_phone:  Faker::PhoneNumber.phone_number,
        job_description: Faker::Lorem.paragraph,
        budget: Faker::Lorem.sentence
      }
    end

    let(:invalid_inquiry) do
      inv_inq = valid_inquiry.dup
      inv_inq.delete(:budget)
    end

    context "with valid inquiry" do
      it "should be able to create a work_inquiry" do
        expect do
          post :create,  { work_inquiry: valid_inquiry}
        end.to change(WorkInquiry, :count).from(0).to(1)
      end

      it "should redirect to confirmation page" do
        expect(post :create,  { work_inquiry: valid_inquiry}).
          to redirect_to(confirmation_hire_us_path)
      end
    end

    context "without valid inquiry" do 
      before { post :create,  { work_inquiry: invalid_inquiry} }
      it { should render_template('show') }
    end

  end

end
