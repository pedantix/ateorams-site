def output_example_content(content)
  puts "\n\n#{'*' * 40}"
  puts "Page:\n\n #{content}"
  puts "#{'*' * 40}\n\n"
end


def output_page_error(example, page)
  if (example.exception and !page.nil? and !page.blank?)
    output_example_content(page.body)
  end
end  