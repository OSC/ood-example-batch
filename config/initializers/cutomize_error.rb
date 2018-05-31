# Add inline Bootstrap form validation errors

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  form_fields = %w(textarea input select)
  elements = Nokogiri::HTML::DocumentFragment
    .parse(html_tag)
    .css("label, #{form_fields.join(", ")}")

  html = ""
  elements.each do |e|
    if e.node_name.eql? "label"
      html = %(#{e})
    elsif form_fields.include? e.node_name
      e["class"] = %(#{e["class"]} is-invalid)
      errors = Array.wrap(instance.error_message).uniq.join(", ")
      html = %(#{e}<div class="invalid-feedback">#{errors}</div>)
    end
  end
  html.html_safe
end
