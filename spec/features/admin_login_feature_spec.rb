require "spec_helper"

feature "logging in an admin", :js do
  given(:approved_admin) { FactoryGirl.create(:approved_admin) }
  given(:unapproved_admin) { FactoryGirl.create(:admin) }

  scenario "should be able to sign in, as an approved admin" do
    visit "/admins/sign_in"
    
    expect(page).not_to have_link("sign out")
    expect(page).to have_content("Admin Sign in")
    expect(page).to have_input(:admin_email)
    expect(page).to have_input(:admin_password)

    sign_in(approved_admin)

    expect(page).to have_content("Signed in successfully.")
    expect(page).to have_link("sign out")
  end


  scenario "should not be able to sign in, as an unapproved admin" do
    sign_in(unapproved_admin)

    expect(page).to have_content("Account is not yet approved.")
    expect(page).not_to have_link("sign out")
  end

  scenario "logging out" do
    sign_in
    expect(page).to have_link("sign out")
    click_link("sign out")
    expect(page).to have_content("Signed out successfully.")
  end


  scenario "logging in with a non existent email address should more or less pass" do
    sign_in build(:admin)

    expect(page).to_not have_link("sign out")
    expect(page).to have_content("Account does not exist.")
  end
end