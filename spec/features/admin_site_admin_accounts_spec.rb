require "spec_helper"

feature "administrating admin accounts", :js do
  let(:admin) { FactoryGirl.create(:approved_admin) }
  let(:site_admin) { FactoryGirl.create(:site_admin) }
  after(:each) { output_page_error example, page }

  given(:unapproved_admins) {
    FactoryGirl.create_list(:admin, 10)
  }

  scenario "should not be able to see 'users' if admin is not site admin" do
    expect(page).not_to have_link('sign out')
    sign_in admin
    expect(page).not_to have_link('users')
    expect(page).to have_link('sign out')
  end

  scenario "should not be able to see 'users' if admin is not site admin" do
    expect(page).not_to have_link('sign out')
    sign_in site_admin
    expect(page).to have_link('sign out')
    expect(page).to have_link('users')
  end

  pending "should have 'edit page' " do
    unapproved_admins
    expect(page).not_to have_link('sign out')
    sign_in site_admin
    visit "/admin_users"
    expect(page).to have_site_title("Admin Users")

    expect(page).to have_content("Unapproved")
    expect(page).to have_content("Approved")
    expect(page).to have_content("Site Admins")

    expect(page).to have_xpath("//div[@class='tabs-content']")
    expect(page).to have_xpath("//div[@class='tabs-content']/div[@class='content active' and @id='unapproved']")
    expect(page).to have_xpath("//div[@class='tabs-content']/div[@class='content' and @id='approved']", visible: false)
    expect(page).to have_xpath("//div[@class='tabs-content']/div[@class='content' and @id='site-admins']", visible: false)

    expect(page).to have_xpath("//table/thead/tr")
    expect(page).to have_xpath("//table/thead/tr/th", text: "User Name")
    expect(page).to have_xpath("//table/thead/tr/th", text: "Id")
    expect(page).to have_xpath("//table/thead/tr/th", text: "Email")
    expect(page).to have_xpath("//table/thead/tr/th", text: "Action")

    unapproved_admins.each do |admin|
      expect(page).to have_xpath("//table/tbody/tr/td[class='admin-id']", text: admin.id ) expect(page).to have_xpath("//table/tbody/tr/td[class='admin-username']", text: admin.username )
      expect(page).to have_xpath("//table/tbody/tr/td[class='admin-email']", text: admin.email )
      expect(page).to have_xpath("//table/tbody/tr/td[class='admin-action']/a", text: 'edit')
    end
  end
end

