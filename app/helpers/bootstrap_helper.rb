module BootstrapHelper
  def bootstrap_button_to(text, url, style, *args)
    args_merged = args.reduce({}, :merge)

    text = (icon args_merged[:icon]) + ' ' + text if args_merged.key? :icon
    args_merged.delete :icon if args_merged.key? :icon

    clazz = 'btn btn-' + style.to_s
    clazz = clazz + ' ' + args_merged[:class] if args_merged.key? :class
    clazz = clazz + ' btn-' + args_merged[:size].to_s if args_merged.key? :size
    args_merged[:class] = clazz
    args_merged.delete :size

    link_to text, url, args_merged
  end

  def bootstrap_button_group(&block)
    ('<div class="btn-group">' + capture(&block) + '</div>').html_safe
  end

  def simple_link_to(text, href)
    content_tag :a, text, href: href
  end

  def affix(id, top, &block)
    ret = '<div class="row"><div class="col-md-9">'
    sections = AffixSectionContainer.new(self)
    ret += capture(sections, &block)
    ret += '</div><div class="col-md-3 scrollspy"><ul id="' + id + '" class="nav hidden-xs hidden-sm" data-spy="affix">'
    ret += sections.render_nav
    ret += '</ul></div></div>'
    ret += '<script type="text/javascript">$(function() { $(\'#' + id + '\').affix({ offset: { top: ' +
           top + ' }});});</script>'
    ret.html_safe
  end

  def gi_icon(key, *args)
    args.clone.each do |arg|
      if arg.is_a?(Hash) && arg.keys.first == :size
        args << { class: 'glyphicon-' + arg[:size].to_s }
        args.delete arg
      end
    end
    icon key, *args
  end

  private

  class AffixSectionContainer
    attr_accessor :sections
    attr_accessor :level

    def initialize(helper, lvl = 1)
      @level = lvl
      @sections = []
      @helper = helper
    end

    def section(id, title, &block)
      children = AffixSectionContainer.new(@helper, @level + 2)
      ret = "<section id=\"#{id}\"><h#{@level}>#{title}</h#{@level}>#{@helper.capture(children, &block)}</section>"
      @sections << {
        id: id,
        title: title,
        children: children
      }
      ret.html_safe
    end

    def render_nav
      ret = ''
      @sections.each do |section|
        ret += '<li><a href="#' + section[:id] + '">' + section[:title] + '</a>'
        unless section[:children].sections.empty?
          ret += '<ul class="nav">' + section[:children].render_nav + '</ul>'
        end
        ret += '</li>'
      end
      ret
    end
  end
end
