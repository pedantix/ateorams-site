require "spec_helper"

feature "admin user can edit their own account", :js do
  let(:admin_user) { FactoryGirl.create(:approved_admin)}
  after(:each) { output_page_error example, page }
  background do
    sign_in admin_user
    visit "/admins/edit"
  end


  scenario "should have a complete password protected form" do
    expect(page).to have_content("Email")
    expect(page).to have_input(:admin_email)
    expect(page).to have_input(:admin_username)
    expect(page).to have_input(:admin_phone)
    expect(page).to have_input(:admin_twitter_handle)
    expect(page).to have_input(:admin_password)
    expect(page).to have_input(:admin_password_confirmation)
    expect(page).to have_input(:admin_current_password)
  end


  scenario "should be able to change password" do
    fill_in "admin_password", with: "password2"
    fill_in "admin_password_confirmation", with: "password2"
    fill_in "admin_current_password", with: admin_user.password
    click_button "Update"

    expect(page).to have_content("You updated your account successfully.")
    click_link "sign out"
    expect(page).to have_content("Signed out successfully.")

    visit "/admins/sign_in"
    fill_in "admin_email", with: admin_user.email
    fill_in "admin_password", with: "password2"

    click_button "Sign in"

    expect(page).to have_content("Signed in successfully.")
  end 


  scenario "should be able to change attributes that are not the password" do
    fill_in "admin_phone", with: "+19042601331"
    fill_in "admin_username", with: "Shaun William Hubbard"
    fill_in "admin_twitter_handle", with: "@hubbardshaunw"
    fill_in "admin_current_password", with: admin_user.password
    click_button "Update"

    expect(page).to have_content("You updated your account successfully.")

    changed = Admin.where(email: admin_user.email).first

    expect(changed.phone).to eql "+19042601331"
    expect(changed.username).to eql "Shaun William Hubbard"
    expect(changed.twitter_handle).to eql "@hubbardshaunw"
  end
end



