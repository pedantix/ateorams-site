require 'spec_helper'


feature "viewing blog admin panel", :js do
  scenario "should be able to see 'posts' as admin" do
    sign_in
    expect(page).to have_link('posts')
    expect(page).to have_link('new post')
    expect(page).to have_link('blog')
  end

  scenario "should not be able to see 'posts' as admin" do
    visit root_path
    expect(page).not_to have_link('posts')
    expect(page).not_to have_link('new post')
    expect(page).to have_link('blog')
  end

end


feature "viewing blog index", :js do
  background do
    FactoryGirl.create_list(:post, 40)
  end

  scenario "as a visitor should be able to view blog index" do
    visit root_path
    click_link 'blog'

    expect(page).to have_site_title "stuff to think on"
    
    Post.all.limit(25).each do |post|
      expect(page).to have_content( post.created_at.strftime("%b %d, %Y"))
      expect(page).to have_content(post.abstract_body)
      expect(page).to have_link(post.title)
    end

    Post.all.offset(25).limit(25).each do |post|
      expect(page).not_to have_content(post.abstract_body)
      expect(page).not_to have_link(post.title)
    end

    expect(page).to have_link("2")
    click_link "2"
    expect(page).to have_link("1")
    Post.all.limit(25).each do |post|
      expect(page).not_to have_content(post.abstract_body)
      expect(page).not_to have_link(post.title)
    end

    Post.all.offset(25).limit(25).each do |post|
      expect(page).to have_content( post.created_at.strftime("%b %d, %Y"))
      expect(page).to have_content(post.abstract_body)
      expect(page).to have_link(post.title)
    end


  end

end


feature "viewing individual blog posts" do
  let!(:post) { Post.first }
  background do
    FactoryGirl.create_list(:post, 10)
    visit root_path

    click_link 'blog'
  end


  pending "should be able to see blog content" do
    click_link Post.first.title
    expect(page).to have_site_title(post.title)
    expect(page).to have_content(post.author)



  end

  pending "redcarpet markdown"
end