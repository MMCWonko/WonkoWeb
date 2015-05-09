module RoutesHelper
  def self.map_to_route_helper(item)
    overrides = {
      user: 'profile'
    }
    guess = ActiveModel::Naming.singular_route_key(if item.is_a? Symbol
                                                     item.constantize
                                                   elsif item.is_a? Class
                                                     item
                                                   elsif item.class.respond_to? :base_class
                                                     item.class.base_class
                                                   else
                                                     item.class
                                                   end).to_sym
    overrides.key?(guess) ? overrides[guess] : guess.to_s
  end

  def form_route(object, *args)
    route(object.persisted? ? :update : :create, object, *args)
  end

  def route(action, *args)
    case args.first
    when WonkoVersion
      route action, args.first.wonko_file, *args
    else
      no_prefix_actions = [:create, :update, :show, :index, :destroy]
      plural_actions = [:create, :index]

      items = args.select { |item| !item.is_a? Hash }
      arguments = args.select { |item| !item.is_a? Class }

      # construct the path:
      # [<prefix>_]<model1>[_<model2>[_<model3>...]][s]_path

      # [<prefix>_]
      method_name = no_prefix_actions.include?(action.to_sym) ? '' : action.to_s + '_'
      # <model1>[_<model2>[_<model3>...]]
      method_name += items.map { |item| RoutesHelper.map_to_route_helper item }.join '_'
      # [s]
      method_name += 's' if plural_actions.include? action.to_sym
      # _path
      method_name += '_path'
      Rails.application.routes.url_helpers.send method_name.to_sym, *arguments
    end
  end
end
