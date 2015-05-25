module ViewHelpers
  def pundit_view_helpers
    before do
      allow(controller).to receive(:current_user).and_return user
      controller.singleton_class.class_eval do
        include Pundit
      end
    end
  end
end
