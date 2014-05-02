module Features
  def sign_in(user = FactoryGirl.create(:approved_admin) )
    visit "/admins/sign_in"
    fill_in "admin_email", with: user.email
    fill_in "admin_password", with: user.password
    click_button "Sign in"
  end
end