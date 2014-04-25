require 'rspec/expectations'


RSpec::Matchers.define :have_site_title do |page_title|
  expected_title = "ATEORAMS| #{page_title}"
  match do |page|
    expect(page).to have_title(expected_title)
  end

  failure_message_for_should do |page|
    %Q|  expected that "#{page.title}", would match "#{expected_title}"|
  end
end


RSpec::Matchers.define :have_apple_touch_icon do |size|
  asset_file_name = "apple-touch-icon-#{size}x#{size}.png"

  link_xpath = "//head/link"
  link_xpath << "["
  #rel
  link_xpath << "@rel='apple-touch-icon'"
  link_xpath << " and @sizes='#{size}'"
  link_xpath << " and @href='/assets/#{asset_file_name}'"

  link_xpath << "]"

  asset_file_url = "#{Rails.root}/app/assets/images/#{asset_file_name}"


  page_valid = true
    
  file_valid = File.exist?(asset_file_url)

  match do |page|
    page_valid = page.has_xpath?(link_xpath, visible: false)

    page_valid and file_valid
  end

  failure_message_for_should do |page|
    msg = ""
    msg << %Q|expected there to be a link to an apple touch icon with size #{size}x#{size} \n\n matching xpath-pattern: #{link_xpath}| unless page_valid
    msg << %Q|\n\n expected a complimentary asset file @url=\n'#{asset_file_url}'|unless file_valid
    msg
  end
end



RSpec::Matchers.define :have_favicon do
  asset_file_name = "favicon.ico"

  link_xpath = "//head/link"
  link_xpath << "["
  #rel
  #link_xpath << "@rel='apple-touch-icon'"
  #link_xpath << " and @sizes='#{size}'"
  link_xpath << "@href='/assets/#{asset_file_name}'"

  link_xpath << "]"

  asset_file_url = "#{Rails.root}/app/assets/images/#{asset_file_name}"


  page_valid = true
    
  file_valid = File.exist?(asset_file_url)

  match do |page|
    page_valid = page.has_xpath?(link_xpath, visible: false)

    page_valid and file_valid
  end

  failure_message_for_should do |page|
    msg = ""
    msg << %Q|expected there to be a link to a favicon\n\n matching xpath-pattern: #{link_xpath}| unless page_valid
    msg << %Q|\n\n expected a complimentary asset file @url=\n'#{asset_file_url}'|unless file_valid
    msg
  end
end

