module ViewHelpers
  def pundit_view_helpers
    before do
      assign(:current_user, user)
      controller.singleton_class.class_eval do
        include Pundit
        attr_reader :current_user
      end
    end
  end
end
