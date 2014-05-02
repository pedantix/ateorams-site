require 'spec_helper'


describe FormHelper do
  let(:required_label) do
    helper.content_tag(:div, "*", class:"required-label")
  end

  let(:error_label) do
    helper.content_tag(:small, "Invalid entry, can't be blank, is invalid.", class:"error")
  end

  let(:work_inquiry) { FactoryGirl.create(:work_inquiry) }


  describe "#text_label" do
    it { expect(helper.required_text_label).to eql required_label }
  end

  describe "#form_error" do
    before do
      work_inquiry.touch
      work_inquiry.client_email = nil
    end

    it "should render a small error tag, when a model object is given with error for attribute" do
      expect(work_inquiry).to be_invalid
      expect(helper.form_error(work_inquiry, :client_email)).to eql(error_label)
    end

    it "should render nothing for attributes without fault" do
      expect(helper.form_error(work_inquiry, :client_phone)).to eql(nil)
    end
  end
end