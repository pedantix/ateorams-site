require "spec_helper"

feature "administrating admin accounts", :js do
  let(:admin) { FactoryGirl.create(:approved_admin) }
  let(:site_admin) { FactoryGirl.create(:site_admin) }

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
end

