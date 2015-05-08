class BootstrapBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
  def render
    return '' unless @elements.size # fail gracefully if no breadcrumbs

    @context.content_tag(:ol, class: 'breadcrumb') do
      @elements.map do |element|
        if @context.current_page? compute_path(element)
          render_active_element element
        else
          render_regular_element element
        end
      end.join.html_safe
    end
  end

  def render_regular_element(element)
    @context.content_tag :li do
      @context.link_to(compute_name(element), compute_path(element),
                       element.options)
    end
  end

  def render_active_element(element)
    @context.content_tag(:li, class: 'active') do
      compute_name(element)
    end
  end
end
