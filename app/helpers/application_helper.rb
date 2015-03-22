module ApplicationHelper
    def bootstrap_button_to(text, url, style, *args)
        argsMerged = args.reduce({}, :merge)
        if argsMerged.key? :icon
            text = (icon argsMerged[:icon]) + ' ' + text
        end
        args.select do |arg|
            not [:icon].include? arg.keys.first
        end
        clazz = 'btn btn-' + style.to_s
        args.each do |arg|
            if arg.keys.first == :class
                clazz = clazz + ' ' + args[:class]
            end
        end
        args << { class: clazz }
        link_to text, url, *args
    end
    def bootstrap_button_group(&block)
        ('<div class="btn-group">' + capture(&block) + '</div>').html_safe
    end
end
