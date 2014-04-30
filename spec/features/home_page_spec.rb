require "spec_helper"


feature "'application' template", :js do
  after(:each) { output_page_error example, page }
  before do
    visit root_path
  end

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

  scenario "should set viewport" do
    expect(page).to have_xpath("//head/meta[@name='viewport' and @content='width=device-width, initial-scale=1.0']", visible: false)
  end
    
  given(:seo_description) do
    "ATEORAMS is a tiny Rails and iOS development consultancy, that can provide development solutions."
  end

  scenario "should have reasonable SEO" do
    expect(page).to have_meta_path({content: seo_description, name: "description"})
    expect(page).to have_meta_path({name: "rights", content: "ATEORAMS Copyright (C) 2014"})

    expect(page).to have_meta_path({name: "keywords", content: "jacksonville, software, ruby, rails, web, apps, websites, ios, osx, cocoa"})
  end


  scenario "should have a topbar with Zurb structure with links to 'blog' and 'hire us'" do
    topbar_xpath = %Q|//header/nav[@class="top-bar" and @data-topbar]|
    expect(page).to have_xpath(topbar_xpath, count: 1)

    title_area_xpath = %Q|#{topbar_xpath}/ul[@class="title-area"]|
    name_xp = %Q|#{title_area_xpath}/li[@class="name"]/h1/a[@href="#{root_path}"]/img[@src='/assets/Attheedgeof-White.png' and @alt="ATEORAMS Home"]|
    dropdown_icon_xp = %Q|#{title_area_xpath}/li[@class="toggle-topbar menu-icon"]/a[@href='#']/span[text()="Menu"]|
    expect(page).to have_xpath(name_xp, count: 1)
    expect(page).to have_xpath(dropdown_icon_xp, count: 1, visible: false)    

    right_nav_xpath = %Q|#{topbar_xpath}/section[@class="top-bar-section"]/ul[@class="right"]|
    expect(page).to have_xpath(right_nav_xpath, count:1)
    
    blog_xpath = %Q|#{right_nav_xpath}/li/a[text()='blog']|
    hire_us_xpath = %Q|#{right_nav_xpath}/li/a[text()='hire us']|
    expect(page).to have_xpath(blog_xpath, count: 1)
    expect(page).to have_xpath(hire_us_xpath, count: 1)
  end
end


feature "home page" do
  scenario "should have the title 'ATEORAMS'" do
    visit root_path
    expect(page).to have_title("ATEORAMS| An App Company!")
    expect(page).to have_site_title("An App Company!")
  end
end

