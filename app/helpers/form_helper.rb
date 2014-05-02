module FormHelper

  def required_text_label
    content_tag(:div, "*", :class => "required-label")
  end

  def form_error(obj, attribute)
    unless obj.errors[attribute].empty?
      error_msg = "Invalid entry, #{obj.errors.messages[attribute].join(", ")}."
      content_tag(:small, error_msg, class: "error")
    end 
  end
end