module SimpleCalendarMod
  class SimpleCalendarFormBuilder < ActionView::Helpers::FormBuilder
    helpers = field_helpers +
              %w(datetime_select) - 
              %w(hidden_field label fields_for)

    helpers.each do |name|
      define_method(name) do |field, *args|
        options = args.last.is_a?(Hash) ? args.pop : {}
        label = label(field, options[:label], :class => options[:label_class])
        @template.content_tag(:p, @template.content_tag(:b, label) + ":<br/>" + super)
      end
    end
  end
end
