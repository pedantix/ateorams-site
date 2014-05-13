require 'spec_helper'

def show_expectations(work_inquiry)
  expect(page).to have_content(work_inquiry.client_email)
  expect(page).to have_content(work_inquiry.client_name)
  expect(page).to have_content(work_inquiry.client_phone)
  expect(page).to have_content(work_inquiry.budget)
  expect(page).to have_content(work_inquiry.job_description)
  expect(page).to have_content(work_inquiry.reference_source)
end

feature "viewing a work request" do
  after(:each) { output_page_error example, page }

  given(:approved_admin) { FactoryGirl.create(:approved_admin)}
  given(:work_inquiry) { FactoryGirl.create(:work_inquiry)}

  background do
    work_inquiry
    sign_in approved_admin
    expect(page).to have_link("work inquiries")
    
    click_link "work inquiries"
    click_link "show details"
  end

  scenario "should show work inquiry and have sub nav of edit and display" do
    expect(page).to have_site_title("Work Inquiry")
    expect(page).to have_xpath("//dl[@class='sub-nav']/dt", text: "Action:")
    expect(page).to have_xpath("//dl[@class='sub-nav']/dd[@class='active']", text: "show")
    expect(page).to have_xpath("//dl[@class='sub-nav']/dd", text: "edit")

    expect(page).to have_content(work_inquiry.client_email)
    expect(page).to have_content(work_inquiry.client_name)
    expect(page).to have_content(work_inquiry.client_phone)
    expect(page).to have_content(work_inquiry.budget)
    expect(page).to have_content(work_inquiry.job_description)
    expect(page).to have_content(work_inquiry.reference_source)

    expect(page).to have_content("Not yet replied.")
  end

  scenario "should be able to nav to edit and mark replied" do
    find("//dl[@class='sub-nav']/dd/a[text()='edit']").click
    expect(page).to have_site_title("Edit Work Inquiry")
    show_expectations(work_inquiry)
    expect(page).to have_input(:work_inquiry_reply)
    expect(page).to have_button("Update")
  end 
end

feature "editing a work inquiry from index page" do
  after(:each) { output_page_error example, page }

  given(:approved_admin) { FactoryGirl.create(:approved_admin)}
  given(:work_inquiry) { FactoryGirl.create(:work_inquiry)}

  background do
    work_inquiry
    sign_in approved_admin
    expect(page).to have_link("work inquiries")
    
    click_link "work inquiries"
    click_link "edit status"
  end

  scenario "marking work inquiry as replied to" do
    check "work_inquiry_reply"
    click_button "Update"

    expect(page).to have_content("Successfully updated status of work inquiry.")    
    expect(page).to have_content('This inquiry has been responded too.')
  end
end