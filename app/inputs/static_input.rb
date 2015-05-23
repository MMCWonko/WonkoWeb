class StaticInput < SimpleForm::Inputs::Base
  attr_reader :options

  def initialize(builder, attribute_name, column, input_type, options = {})
    super
    @options = options
  end

  def input(wrapper_options = nil)
    input_html_options[:type] ||= :password
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    template.content_tag :div, class: 'input-group' do
      res = ''
      res += template.content_tag :span, class: 'input-group-btn' do
        template.content_tag :a, 'Show',
                             class: 'btn btn-danger',
                             type: :button,
                             href: '#',
                             onclick: 'javascript:toggleShown(this);'
      end
      res += @builder.text_field(attribute_name, merged_input_options)
      res += template.content_tag :span, class: 'input-group-btn' do
        template.content_tag :a, 'Reset', class: 'btn btn-danger', type: :button, href: options[:reset_path]
      end
      res.html_safe
    end
  end
end
