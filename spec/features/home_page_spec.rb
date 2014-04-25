require "spec_helper"


feature "layout" do
  after(:each) { output_page_error example, page }
  scenario "should have icons" do
    visit root_path
    expect(page).to have_apple_touch_icon("114")
    expect(page).to have_apple_touch_icon("120")
    expect(page).to have_apple_touch_icon("144")
    expect(page).to have_apple_touch_icon("152")
    expect(page).to have_apple_touch_icon("57")
    expect(page).to have_apple_touch_icon("72")
    expect(page).to have_apple_touch_icon("76")
    
    expect(page).to have_favicon
  end
end


feature "home page" do
  scenario "should have the title 'ATEORAMS'" do
    visit root_path
    expect(page).to have_title("ATEORAMS| An App Company!")
    expect(page).to have_site_title("An App Company!")
  end
end

