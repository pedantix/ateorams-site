require 'spec_helper'


feature "the hire us form", :js do
  after(:each) { output_page_error example, page }

  scenario "should have fields and labels for 'WorkInquiry'" do
    visit root_path
    click_link "hire us"

    #form basics
    expect(page).to have_site_title("Hire Us")
    expect(page).to have_xpath("//h2", "Hire ATEORAMS")
    expect(page).to have_input(:work_inquiry_client_name).placeholder("What shall we call you?")
    expect(page).to have_input(:work_inquiry_client_email).placeholder("What email address should we use?")
    expect(page).to have_input(:work_inquiry_client_phone).placeholder("What phone number should we call you at?")
    expect(page).to have_input(:work_inquiry_budget).placeholder("How much do you have budgeted for this project?")
    expect(page).to have_textarea(:work_inquiry_job_description).placeholder("What do you want to hire us to do...")
    expect(page).to have_button("submit")
  
    # #form placeholders
    # expect(page).to have_content("Who are you?")

  end
end