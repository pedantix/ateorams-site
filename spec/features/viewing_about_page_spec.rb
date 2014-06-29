require 'spec_helper'


feature 'About page' do
  background do
    visit root_path
    click_link "about"
    expect(page).to have_site_title("About")
  end
  


  scenario "as a user I should see the following" do

    expect(true).to be_true

  end
end