module ApplicationHelper
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def new_child_fields_template(form_builder, association, options = {}, locals = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= association.to_s.singularize
    options[:form_builder_local] ||= :f

    content_tag(:script, :id => "#{association}_fields_template", :type => 'text/html') do
      form_builder.fields_for(association, options[:object], :child_index => "NEW_RECORD") do |f|
        render(:partial => options[:partial], :locals => {options[:form_builder_local] => f}.merge(locals))
      end
    end
  end

  def conditional_class(condition, klass)
    if condition
    klass
    end
  end
  
  def parent_layout(layout)
    @_content_for[:layout] = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
  end



end



