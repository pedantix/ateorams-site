require 'spec_helper'


feature "editing posts", :js do
  given(:md_post) { FactoryGirl.create(:post, body: "This is *markdown*, indeed.", tags_text: "javascript, ruby, MarkDown")}
  given(:admin) { FactoryGirl.create(:approved_admin) }

  background do
    md_post.admins  = [admin]     
  end


  scenario "should be able to edit post as author" do
    sign_in admin
    visit blogs_path
    click_link md_post.title

    expect(page).to have_link("edit post")
    click_link "edit post"

    expect(page).to have_title("Edit: #{md_post.title}") 
    expect(page).to have_input("post_title")
    expect(page).to have_input("post_tags_text")
    expect(page).to have_textarea("post_body")
    expect(page).to have_button("Update Blog")

    fill_in "post_title", with: "Yet another, New Hope!"
    fill_in "post_tags_text", with: "Star Wars, Ruby, ActionController::Live"
    fill_in "post_body", with: "We in the rails community can now compete thanks to tireless work of those that wrote action controller live alowing for asynchronous servers to perform streaming text, YAY!"
    click_button "Update Blog"

    expect(page).to have_site_title("Yet another, New Hope!")
  end

  scenario "should be able to edit post as 'site admin'" do
    sign_in create(:site_admin)
    visit blogs_path
    click_link md_post.title

    expect(page).to have_link("edit post")
    click_link "edit post"

    expect(page).to have_title("Edit: #{md_post.title}") 
    expect(page).to have_input("post_title")
    expect(page).to have_input("post_tags_text")
    expect(page).to have_textarea("post_body")
    expect(page).to have_button("Update Blog")

    fill_in "post_title", with: "Yet another, New Hope!"
    fill_in "post_tags_text", with: "Star Wars, Ruby, ActionController::Live"
    fill_in "post_body", with: "We in the rails community can now compete thanks to tireless work of those that wrote action controller live alowing for asynchronous servers to perform streaming text, YAY!"
    click_button "Update Blog"

    expect(page).to have_site_title("Yet another, New Hope!")
  end

  scenario "should not be able to edit post as 'other admin'" do
    sign_in create(:admin)
    visit blogs_path
    click_link md_post.title

    expect(page).not_to have_link("edit post")
  end


  scenario "should not be able to edit post as 'visitor'" do

    visit blogs_path
    click_link md_post.title

    expect(page).not_to have_link("edit post")
  end
end