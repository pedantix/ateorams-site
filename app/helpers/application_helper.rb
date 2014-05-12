module ApplicationHelper
  @@md_renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new)

  def render_markdown(text)
    @@md_renderer.render(text).html_safe
  end


  def date_to_appstring(date)
    date.strftime("%b %d, %Y")
  end
end
