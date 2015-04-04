module RoutesHelper
  def route(action, *args)
    if args.first.is_a? WonkoVersion
      route action, args.first.wonkofile, *args
    else
      no_prefix_actions = [:create, :show, :index, :destroy]
      plural_actions = [:index]

      items = args.select { |item| !item.is_a? Hash }
      arguments = args.select { |item| !item.is_a? Class }

      method_name = no_prefix_actions.include?(action.to_sym) ? '' : action.to_s + '_'
      method_name += items.map { |item| item.model_name.singular }.join '_'
      method_name += 's' if plural_actions.include? action.to_sym
      method_name += '_path'
      Rails.application.routes.url_helpers.send method_name.to_sym, *arguments
    end
  end
end
