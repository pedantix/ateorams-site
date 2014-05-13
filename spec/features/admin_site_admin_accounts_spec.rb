require "spec_helper"

feature "administrating admin accounts", :js do
  given(:admin_user) { FactoryGirl.create(:approved_admin) }
  given(:site_admin) { FactoryGirl.create(:site_admin) }
  after(:each) { output_page_error example, page }

  given(:sample_admins) {
    FactoryGirl.create_list(:admin, 10)
    FactoryGirl.create_list(:approved_admin, 10)
    FactoryGirl.create_list(:site_admin, 10)
  }


  scenario "should not be able to see 'users' if admin is not site admin" do
    expect(page).not_to have_link('sign out')
    sign_in admin_user
    expect(page).not_to have_link('users')
    expect(page).to have_link('sign out')
  end

  scenario "should not be able to see 'users' if admin is not site admin" do
    expect(page).not_to have_link('sign out')
    sign_in site_admin
    expect(page).to have_link('sign out')
    expect(page).to have_link('users')
  end

  # I dont expect a need for pagination so I am not building it
  scenario "should have 'index page' w tabbed browsing of site adminstrators " do
    sample_admins
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

    expect(Admin.unapproved_admins.count).to eql(10) 

    Admin.unapproved_admins.each do |admin|
      table_row_xp = "//table/tbody/tr[@class='admin-#{admin.id}']"
      expect(page).to have_xpath("#{table_row_xp}/td[@class='admin-id']", text: admin.id )
      expect(page).to have_xpath("#{table_row_xp}/td[@class='admin-username']", text: admin.username )
      expect(page).to have_xpath("#{table_row_xp}/td[@class='admin-email']", text: admin.email )
      expect(page).to have_xpath("#{table_row_xp}/td[@class='admin-action']/a", text: 'edit')
    end

    click_link "Approved"

    Admin.approved_admins.each do |admin|
      table_row_xp = "//table/tbody/tr[@class='admin-#{admin.id}']"     
      expect(page).to have_xpath("#{table_row_xp}/td[@class='admin-id']", text: admin.id, visible: false )
      expect(page).to have_xpath("#{table_row_xp}/td[@class='admin-username']", text: admin.username, visible: false )
      expect(page).to have_xpath("#{table_row_xp}/td[@class='admin-email']", text: admin.email, visible: false )
      expect(page).to have_xpath("#{table_row_xp}/td[@class='admin-action']/a", text: 'edit', visible: false)
    end

    Admin.site_admins.each do |admin|
      table_row_xp = "//table/tbody/tr[@class='admin-#{admin.id}']"
      expect(page).to have_xpath("#{table_row_xp}/td[@class='admin-id']", text: admin.id, visible: false )
      expect(page).to have_xpath("#{table_row_xp}/td[@class='admin-username']", text: admin.username, visible: false )
      expect(page).to have_xpath("#{table_row_xp}/td[@class='admin-email']", text: admin.email, visible: false )
      
      if admin.id.equal?(site_admin.id)
        expect(page).not_to have_xpath("#{table_row_xp}/td[@class='admin-action']/a", text: 'edit', visible: false)
      else
        expect(page).to have_xpath("#{table_row_xp}/td[@class='admin-action']/a", text: 'edit', visible: false)
      end
    end
  end

  let(:unapproved_admin) { FactoryGirl.create(:admin) }
  scenario "should be able to approve an admin account" do
    unapproved_admin
    sign_in site_admin

    visit admin_users_path #hack around zurb
    expect(page).to have_link("edit")
    find(:xpath, "//tr[@class='admin-#{unapproved_admin.id}']/td/a[text()='edit']").click
    
    expect(page).to have_site_title("Edit #{unapproved_admin.username}'s Account")
    expect(page).to have_selector('legend', 'Edit Admin Privileges')
    expect(page).to have_selector('legend', 'Site Access')
    expect(page).to have_input(:admin_site_admin) 
    expect(page).to have_input(:admin_approved) 
    expect(page).to have_button("Update")

    check "admin_approved"
    click_button "Update"
    expect(page).to have_content("User privileges updated successfully.")
  end
end

