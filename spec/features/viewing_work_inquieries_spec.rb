require 'spec_helper'

feature "work inquiries tab", :js do
  background do
    visit root_path
  end
  after(:each) { output_page_error example, page }

  given(:approved_admin) { FactoryGirl.create(:approved_admin)}
  scenario "should show work inquiries to apprved admins" do
    sign_in approved_admin
    expect(page).to have_link("work inquiries")
  end

  scenario "should not show work inquiries to non signed in user" do

  end
end

feature "work inquires index", :js do
  after(:each) { output_page_error example, page }
  given(:approved_admin) { FactoryGirl.create(:approved_admin)}
  given(:work_inquiries) { FactoryGirl.create_list(:work_inquiry, 13) }
  given(:replied_inquiries) { FactoryGirl.create_list(:replied_inquiry, 25) }

  background do
    work_inquiries; replied_inquiries;
    sign_in approved_admin
    click_link "work inquiries"
  end

  scenario "work inquiries index layout" do
    expect(page).to have_site_title("Work Inquiries")

    expect(page).to have_xpath("//dl[@class='sub-nav']/dt", text: "FILTER:")
    expect(page).to have_xpath("//dl[@class='sub-nav']/dd[@class='active']", text: "All")
    expect(page).to have_xpath("//dl[@class='sub-nav']/dd", text: "Answered")
    expect(page).to have_xpath("//dl[@class='sub-nav']/dd", text: "Unanswered")

    #page 1
    WorkInquiry.all.limit(10).each do |inquiry|
      #contact info
      expect(page).to have_content(inquiry.budget)
      expect(page).to have_content(inquiry.job_description)

      #contact info
      expect(page).to have_content(inquiry.client_name)      
    end
    ###pagination
    expect(page).to have_link("2")
    expect(page).to have_link("3")

    click_link "2"

    #page 2
    WorkInquiry.all.offset(10).limit(10).each do |inquiry|
      #contact info
      expect(page).to have_content(inquiry.budget)
      expect(page).to have_content(inquiry.job_description)

      #contact info
      expect(page).to have_content(inquiry.client_name)      
    end

  end

  scenario "replied inquiries, should be paginated by 10" do
    click_link "Answered"
    expect(page).to have_xpath("//dl[@class='sub-nav']/dd[@class='active']", text: "Answered")

    #page 1
    WorkInquiry.answered.limit(10).each do |inquiry|
      #contact info
      expect(page).to have_content(inquiry.budget)
      expect(page).to have_content(inquiry.job_description)

      #contact info
      expect(page).to have_content(inquiry.client_name)

      expect(page).to have_xpath("//a[@id='show-inquiry-#{inquiry.id}']")
      expect(page).to have_xpath("//a[@id='edit-inquiry-#{inquiry.id}']")  
    end
    ###pagination
    expect(page).to have_link("2")
    expect(page).to have_link("3")
     WorkInquiry.unanswered.each do |inquiry|
      expect(page).not_to have_xpath("//a[@id='show-inquiry-#{inquiry.id}']")
      expect(page).not_to have_xpath("//a[@id='edit-inquiry-#{inquiry.id}']")
    end

    click_link "2"

    WorkInquiry.answered.offset(10).limit(10).each do |inquiry|
      #contact info
      expect(page).to have_content(inquiry.budget)
      expect(page).to have_content(inquiry.job_description)

      #contact info
      expect(page).to have_content(inquiry.client_name)

      expect(page).to have_xpath("//a[@id='show-inquiry-#{inquiry.id}']")
      expect(page).to have_xpath("//a[@id='edit-inquiry-#{inquiry.id}']")  
    end

     WorkInquiry.unanswered.each do |inquiry|
      expect(page).not_to have_xpath("//a[@id='show-inquiry-#{inquiry.id}']")
      expect(page).not_to have_xpath("//a[@id='edit-inquiry-#{inquiry.id}']")
    end
  end

  scenario "unreplied inquiries, should be paginated by 10" do
    click_link "Unanswered"
    expect(page).to have_xpath("//dl[@class='sub-nav']/dd[@class='active']", text: "Unanswered")

    #page 1
    WorkInquiry.unanswered.limit(10).each do |inquiry|
      #contact info
      expect(page).to have_content(inquiry.budget)
      expect(page).to have_content(inquiry.job_description)

      #contact info
      expect(page).to have_content(inquiry.client_name)

      expect(page).to have_xpath("//a[@id='show-inquiry-#{inquiry.id}']")
      expect(page).to have_xpath("//a[@id='edit-inquiry-#{inquiry.id}']")  
    end
    ###pagination
    expect(page).to have_link("2")
    expect(page).to_not have_link("3")
     WorkInquiry.answered.each do |inquiry|
      expect(page).not_to have_xpath("//a[@id='show-inquiry-#{inquiry.id}']")
      expect(page).not_to have_xpath("//a[@id='edit-inquiry-#{inquiry.id}']")
    end

    click_link "2"

    WorkInquiry.unanswered.offset(10).limit(10).each do |inquiry|
      #contact info
      expect(page).to have_content(inquiry.budget)
      expect(page).to have_content(inquiry.job_description)

      #contact info
      expect(page).to have_content(inquiry.client_name)

      expect(page).to have_xpath("//a[@id='show-inquiry-#{inquiry.id}']")
      expect(page).to have_xpath("//a[@id='edit-inquiry-#{inquiry.id}']")  
    end

     WorkInquiry.answered.each do |inquiry|
      expect(page).not_to have_xpath("//a[@id='show-inquiry-#{inquiry.id}']")
      expect(page).not_to have_xpath("//a[@id='edit-inquiry-#{inquiry.id}']")
    end
  end
end