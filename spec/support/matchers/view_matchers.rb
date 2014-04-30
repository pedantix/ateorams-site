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



RSpec::Matchers.define :have_meta_path do |meta_ast_hash|
  meta_content_str = ""

  meta_ast_hash.each do |k,v| 
    meta_content_str << " and " unless meta_content_str.length == 0
    meta_content_str << "@#{k}='#{v}'"
  end
  expected_xpath ="//head/meta[#{meta_content_str}]" 
  match do |p|
    p.has_xpath?(expected_xpath, visible:false)
  end

  failure_message_for_should do |page|
    %Q|  expected that the page would have desire meta tag, which would match "#{expected_xpath}"|
  end
end


def form_field_xpaths(attr_tag_id, input_type, ph_text=nil)
  input_xpath = %Q|//#{input_type}[@id="#{attr_tag_id}"|
  input_xpath << %Q| and @placeholder="#{ph_text}"| unless ph_text.nil? or ph_text.empty?
  input_xpath << "]"

  [%Q|//label[@for="#{attr_tag_id}"]|,
   input_xpath]
end

def form_field_fail_msg(attr_tag_id, expected_xpaths)
   %Q|  expected that the page would have a form input for attribute #{attr_tag_id}
        with a label_xpath: #{expected_xpaths.first}"
        and input_xpath: "#{expected_xpaths.last}"|
end

RSpec::Matchers.define :have_input do |attr_tag_id|
  chain :placeholder do |t|
    @placeholder_text = t
  end

  match do |p|
    @expected_xpaths = form_field_xpaths(attr_tag_id, 'input', @placeholder_text)

    p.has_xpath?(@expected_xpaths.first) and p.has_xpath?(@expected_xpaths.last)
  end

  failure_message_for_should do |page|
    form_field_fail_msg(attr_tag_id, @expected_xpaths)   
  end
end

RSpec::Matchers.define :have_textarea do |attr_tag_id|
  chain :placeholder do |t|
    @placeholder_text = t
  end

  match do |p|
    @expected_xpaths = form_field_xpaths(attr_tag_id, 'textarea', @placeholder_text)
    p.has_xpath?(@expected_xpaths.first) and p.has_xpath?(@expected_xpaths.last)
  end

  failure_message_for_should do |page|
    form_field_fail_msg(attr_tag_id, @expected_xpaths)   
  end
end
