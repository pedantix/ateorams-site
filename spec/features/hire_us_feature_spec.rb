require 'spec_helper'



feature "the 'hire us' form", :js do
  after(:each) { output_page_error example, page }

  scenario "should have fields and labels for 'WorkInquiry'" do
    navigate_to_hire_us

    #form 
    expect(page).to have_site_title("Hire Us")
    expect(page).to have_xpath("//h2", "Hire ATEORAMS")
    expect(page).to have_input(:work_inquiry_client_name).placeholder("What is your name?")
    expect(page).to have_input(:work_inquiry_client_email).placeholder("What email address should we use?")
    expect(page).to have_input(:work_inquiry_client_phone).placeholder("What is your best contact phone number?")
    expect(page).to have_input(:work_inquiry_budget).placeholder("How much do you have budgeted for this project?")
    expect(page).to have_textarea(:work_inquiry_job_description).placeholder("Describe the project...")
    expect(page).to have_input(:work_inquiry_reference_source).placeholder("How did you hear about us?")
   
    expect(page).to have_button("submit")
  end
end


feature "submitting the 'hire us form' with invalid info", :js do
  after(:each) { output_page_error example, page }
  before(:each) do
     navigate_to_hire_us
  end

  scenario "should reject input when the input is invalid" do
    expect do 
        click_button 'submit'
    end.not_to change(WorkInquiry, :count)

    expect(page).to have_xpath("//h2", "Hire ATEORAMS")
    expect(page).to have_xpath("//small[@class='error']", count: 5)
    expect(page).to have_content("Your inquiry was not submitted, see the form below for errors.")
    expect(page).to have_xpath("//a[@class='close']")
  end
end 


feature "submitting the 'hire us form' with invalid info", :js do
  after(:each) { output_page_error example, page }
  before(:each) do
    clear_emails
    navigate_to_hire_us

    fill_in "work_inquiry_client_name", with: Faker::Name.name
    fill_in "work_inquiry_client_email", with: 'test@example.com'
    fill_in "work_inquiry_client_phone", with: Faker::PhoneNumber.phone_number
    fill_in "work_inquiry_budget", with: Faker::Lorem.sentence
    fill_in "work_inquiry_job_description", with: Faker::Lorem.paragraph
    fill_in "work_inquiry_reference_source", with: Faker::Lorem.sentence

    click_button 'submit'
  end

  scenario "should create a 'work_inquiry', and redirect to 'confirmation' screen" do
    expect(page).to have_content("Your inquiry was succesfully submitted.")    
    expect(page).to have_site_title("Request Received")
    expect(page).to have_selector('h2', 'Thank you, for your interest!')
    expect(page).to have_content("A confirmation email has been sent to the email account you provided, and we are now aware of your interst. A representative from ATEORAMS will be in contact with you shortly.")

    expect(page).to have_content("Every application is crafted with a customer-centric focus. We look forward to working with you to develop this application.")
  end


  scenario "should create multipart-email confirmation" do
    expect(page).to have_site_title("Request Received")
    
    open_email('test@example.com')
    expect(current_email.subject).to eql 'Request Received. Thank you, for your interest!'
  
    current_email.save_and_open
  end
end