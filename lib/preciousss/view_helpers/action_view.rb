module Preciousss
  module ViewHelpers
    module ActionView

      def body_class
        qualified_controller_name = controller.controller_path.gsub('/', '_')
        "#{qualified_controller_name} #{controller.action_name} #{qualified_controller_name}_#{controller.action_name} #{I18n.locale}"
      end

      def body_id
        "#{controller.controller_path.gsub('/', '_')}_body"
      end

      def flash_messages
        return if flash.blank?

        content_tag(:div, :class => "flash_messages #{flash.keys.map{|key| "with_#{key}"}.join(' ')}") do
          flash.map{|key, value| content_tag(:p, content_tag(:span, value), :class => "flash_messages flash_#{key}")}.join.html_safe
        end
      end

      def years_range(since = Date.today.year, till = Date.today.year)
        @copyright_year ||= [since, till].uniq.sort.join('-')
      end

    end
  end
end
