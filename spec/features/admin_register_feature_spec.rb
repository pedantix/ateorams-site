require 'spec_helper'


feature "registering an admin", :js do
  let!(:last_admin) { Admin.last }
  let(:user_email) { "shaun.hubbard@example.com" }
  let(:user_name) { "Shaun Hubbard"}
  after(:each) { output_page_error example, page }
 

  scenario "should be able to register an admin, with minimal valid information" do
    visit "/admins/sign_in"
    click_link "Sign up"

    expect(page).to have_input(:admin_email)
    expect(page).to have_input(:admin_password)
    expect(page).to have_input(:admin_password_confirmation)

    expect(page).to have_input(:admin_username)
    expect(page).to have_input(:admin_phone)
    expect(page).to have_input(:admin_twitter_handle)
    expect(page).to have_button("Sign up")

    fill_in "admin_email", with: user_email
    fill_in "admin_password", with: "password"
    fill_in "admin_password_confirmation", with: "password"
    fill_in "admin_username", with: user_name
    click_button "Sign up"
    
    expect(page).to have_content("However, we could not sign you in because your account is not yet activated.")
    new_user = Admin.where(email: user_email).first
    
    expect(new_user).not_to be_nil
    expect(new_user.username).to eql user_name
    expect(new_user.twitter_handle).to eq ""
  end 

  scenario "should be able to register an admin, with valid information" do
    visit "/admins/sign_in"
    click_link "Sign up"

    fill_in "admin_email", with: user_email
    fill_in "admin_password", with: "password"
    fill_in "admin_password_confirmation", with: "password"
    fill_in "admin_username", with: user_name
    fill_in "admin_twitter_handle", with: "@hubbard_shaun_w"
    fill_in "admin_phone", with: "+1913371337"
    click_button "Sign up"
    
    expect(page).to_not have_content("Welcome! You have signed up successfully.")
    expect(page).to have_content("However, we could not sign you in because your account is not yet activated.")

    expect(page).not_to have_link("sign out")
    new_user = Admin.where(email: user_email).first
    
    expect(new_user).not_to be_nil
    expect(new_user.username).to eql user_name
    expect(new_user.twitter_handle).to eq "@hubbard_shaun_w"
    expect(new_user.phone).to eq "+1913371337"
  end

  scenario "should not be able to register an admin, with invalid information" do
    visit "/admins/sign_in"
    click_link "Sign up"

    fill_in "admin_email", with: user_email
    fill_in "admin_password", with: "passwor"
    fill_in "admin_password_confirmation", with: "password"
    fill_in "admin_username", with: user_name
    fill_in "admin_twitter_handle", with: "@hubbard_shaun_w"
    fill_in "admin_phone", with: "+1913371337"
    
    click_button "Sign up"
    
    expect(page).to have_content("There was an error in the registration.")
    new_user = Admin.where(email: user_email).first
    expect(new_user).to be_nil
  end
end