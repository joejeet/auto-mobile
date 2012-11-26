# http://ethilien.net/archives/fixing-divfieldwitherrors-in-ruby-on-rails/
# https://rails.lighthouseapp.com/projects/8994/tickets/1626-fieldwitherrors-shouldnt-use-a-div
#ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| "<span class=\"fieldWithErrors\">#{html_tag}</span>" }
#ActionView::Base.field_error_proc = proc {|html, instance| html }

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  class_attr_index = html_tag.index 'class="'

  if html_tag =~ /<(input|textarea|select)/
    if class_attr_index
      html_tag.insert class_attr_index+7, 'error '
    else
      html_tag.insert html_tag.index('>'), ' class="error"'
    end
  else
    html_tag
  end
end