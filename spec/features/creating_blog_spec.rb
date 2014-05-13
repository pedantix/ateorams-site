require 'spec_helper'


feature "as an approved site user", :js do
  given(:admin) { FactoryGirl.create(:approved_admin) }
  after(:each) { output_page_error example, page }



  scenario "should be able to create a new post" do
    sign_in admin 

    ##foundation workaround
    expect(page).to have_xpath("//li/a[text()='new post' and @href='#{new_blog_path}']")
    #verify link then simulate click
    visit new_blog_path

    expect(page).to have_title("New Blog Post") 
    expect(page).to have_input("post_title")
    expect(page).to have_input("post_tags_text")
    expect(page).to have_textarea("post_body")
    expect(page).to have_button("Post To Blog")

    fill_in "post_title", with: "A New Hope!"
    fill_in "post_tags_text", with: "Star Wars, Ruby, ActionController::Live"
    fill_in "post_body", with: "We in the rails community can now compete thanks to tireless work of those that wrote action controller live alowing for asynchronous servers to perform streaming text, YAY!"
    click_button "Post To Blog"

    expect(page).to have_site_title("A New Hope!")
    expect(page).to have_content("Post Successfully added.")
    expect(page).to have_link("Ruby")
    expect(page).to have_link("Star Wars")
    expect(page).to have_link("ActionController::Live")
    expect(page).to have_content("#{admin.username}") 
  end

  scenario "shoud have errors with incorrect info when creating a blog post" do
    sign_in admin 

    ##foundation workaround
    expect(page).to have_xpath("//li/a[text()='new post' and @href='#{new_blog_path}']")
    #verify link then simulate click
    visit new_blog_path

    expect(page).to have_title("New Blog Post") 
    expect(page).to have_input("post_title")
    expect(page).to have_input("post_tags_text")
    expect(page).to have_textarea("post_body")
    expect(page).to have_button("Post To Blog")

    fill_in "post_title", with: "a"
    fill_in "post_tags_text", with: "Star Wars, Ruby, ActionController::Live"
    fill_in "post_body", with: "We in the rails community can now compete thanks to tireless work of those that wrote action controller live alowing for asynchronous servers to perform streaming text, YAY!"
    click_button "Post To Blog"

    expect(page).not_to have_site_title("A New Hope!")
    expect(page).to have_content("There was an error creating your post.")
  end
end