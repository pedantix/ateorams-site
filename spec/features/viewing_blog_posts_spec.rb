require 'spec_helper'


feature "viewing blog admin panel", :js do
  after(:each) { output_page_error example, page }
 
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
  given(:old_blog) { FactoryGirl.create(:post) }
  given(:new_blog) { FactoryGirl.create(:post) }
  given(:blog_filler) { FactoryGirl.create_list(:post, 40) }


  background do
    Timecop.travel(3.months.ago) do
      old_blog
    end
    Timecop.travel(1.months.ago) do
      blog_filler
    end
    Timecop.return
    new_blog

  end
  after(:each) { output_page_error example, page }

  scenario "as a visitor should be able to view blog index" do
    visit root_path
    click_link 'blog'

    expect(page).to have_site_title "stuff to think on"
    
    ### expect new blog to be visible
    expect(page).to have_content( new_blog.created_at.strftime("%b %d, %Y"))
    expect(page).to have_content(new_blog.abstract_body)
    expect(page).to have_link(new_blog.title)

    ## expect old blog to not be visible
    expect(page).not_to have_content(old_blog.created_at.strftime("%b %d, %Y"))
    expect(page).not_to have_content(old_blog.abstract_body)
    expect(page).not_to have_link(old_blog.title)

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


feature "viewing blog posts" do
  given(:md_blog_post) { FactoryGirl.create(:post, body: "This is *markdown*, indeed.", tags_text: "javascript, ruby, MarkDown")}
  given(:other_tagged_post) { FactoryGirl.create(:post, tags_text: "markdown") }
  after(:each) { output_page_error example, page }
  
  background do
    md_blog_post
    other_tagged_post
    visit root_path

    click_link 'blog'
  end

  scenario "should process markdown and present it as html" do
    expect(page).to have_xpath("//span[@class='text-justify']/p", text: "This is")
    expect(page).to have_xpath("//span[@class='text-justify']/p/em", text: "markdown")
  
    click_link md_blog_post.title

    expect(page).to have_site_title(md_blog_post.title)

    expect(page).to have_content md_blog_post.title 

    expect(page).to have_xpath("//span[@class='text-justify']/p", text: "This is")
    expect(page).to have_xpath("//span[@class='text-justify']/p/em", text: "markdown")
 
    expect(page).to have_content(md_blog_post.author)
    expect(page).to have_content(md_blog_post.created_at.strftime("%b %d, %Y"))
  
    expect(page).to have_link("MarkDown")
    expect(page).to have_link("ruby")
    expect(page).to have_link("javascript")

  end

  scenario "viewing tags from  blog tag" do
    click_link md_blog_post.title

    expect(page).to have_link "MarkDown"
    click_link "MarkDown"

    expect(page).to have_site_title("Tags: MarkDown")
    expect(page).to have_content( md_blog_post.created_at.strftime("%b %d, %Y"))
    expect(page).to have_link(md_blog_post.title)
    expect(page).to have_content(other_tagged_post.created_at.strftime("%b %d, %Y"))
    expect(page).to have_link(other_tagged_post.title)
  end
end