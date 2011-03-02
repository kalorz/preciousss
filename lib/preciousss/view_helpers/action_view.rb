module Preciousss
  module ViewHelpers
    module ActionView

      def body_class
        qualified_controller_name = controller.controller_path.gsub('/', '-')
        "#{qualified_controller_name} #{controller.action_name} #{qualified_controller_name}-#{controller.action_name} #{I18n.locale}"
      end

      def body_id
        "#{controller.controller_path.gsub('/', '-')}-body"
      end

    end
  end
end