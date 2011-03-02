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

      def flash_messages
        return if flash.blank?

        content_tag(:div, :class => "flash-messages #{flash.keys.map{|key| "with-#{key}"}.join(' ')}") do
          flash.map{|key, value| content_tag(:p, value, :class => "flash-#{key}")}.join.html_safe
        end
      end

    end
  end
end