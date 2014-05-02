module Features
  def navigate_to_hire_us
    visit root_path
    click_link "hire us"
  end
end