require 'spec_helper'

feature "recovering user account", :js do
  after(:each) { output_page_error example, page }

  given(:approved_admin) { FactoryGirl.create(:approved_admin)}
  given(:unapproved_admin) { FactoryGirl.create(:admin)}
 
  background do
    clear_emails
  end

  scenario "should be able to recover user account of an approved user, using a good password" do
    visit new_admin_password_path

    expect(page).to have_input(:admin_email)
    expect(page).to have_button("Send me reset password instructions")
    expect(page).to have_link "Sign in"
    expect(page).to have_link "Sign up"

    fill_in "admin_email", with: approved_admin.email
    click_button "Send me reset password instructions"

    expect(page).to have_content("You will receive an email with instructions on how to reset your password in a few minutes.")
    open_email(approved_admin.email)
    current_email.click_link("Change my password")

    expect(page).to have_content("Change your password")
    expect(page).to have_input(:admin_password)
    expect(page).to have_input(:admin_password_confirmation)
    expect(page).to have_button("Change my password")
    expect(page).to have_link("Sign in")

    fill_in "admin_password", with: "password"
    fill_in "admin_password_confirmation", with: "password"

    click_button "Change my password"

    expect(page).to have_content("Your password was changed successfully. You are now signed in.")
  end

  scenario "should not be able to recover user account of an approved user, using a bad password" do
    visit new_admin_password_path

    expect(page).to have_link "Sign up"

    fill_in "admin_email", with: approved_admin.email
    click_button "Send me reset password instructions"

    expect(page).to have_content("You will receive an email with instructions on how to reset your password in a few minutes.")
    
    open_email(approved_admin.email)
    current_email.click_link("Change my password")

    expect(page).to have_link("Sign in")

    fill_in "admin_password", with: "password"
    fill_in "admin_password_confirmation", with: "passworD"

    click_button "Change my password"

    expect(page).to have_content("There was an error in the registration.")
  end


  scenario "should not be able to recover unapproved account", :focus do
    visit new_admin_password_path

    expect(page).to have_link "Sign up"

    fill_in "admin_email", with: unapproved_admin.email
    click_button "Send me reset password instructions"

    expect(page).to have_content("You will receive an email with instructions on how to reset your password in a few minutes.")
    
    open_email(unapproved_admin.email)
    current_email.click_link("Change my password")

    expect(page).to have_link("Sign in")

    fill_in "admin_password", with: "password"
    fill_in "admin_password_confirmation", with: "password"

    click_button "Change my password"

    expect(page).not_to have_content("Your password was changed successfully. You are now signed in.")
  end
end