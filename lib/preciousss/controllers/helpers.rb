module Preciousss
  module Controllers
    module Helpers
      BOTS_REGEXP = /\b(Googlebot|facebookexternalhit|Baidu|Gigabot|libwww-perl|lwp-trivial|msnbot|SiteUptime|Slurp|WordPress|ZIBB|ZyBorg)\b/i

      def self.included(base) # :nodoc:
        base.extend ClassMethods
        base.send :include, InstanceMethods
        base.class_eval do
          helper_method :errors_for, :is_bot?, :bot_id
        end
      end

      module ClassMethods
      end

      module InstanceMethods

        def is_bot?
          @is_bot ||= !bot_id.blank?
        end

        def bot_id
          @bot_id ||= (request.user_agent.to_s =~ BOTS_REGEXP) && $1
        end
        
        def errors_for(*params)
          options             = params.extract_options!.symbolize_keys
          options[:on]        = [*options[:on]].compact
          options[:except_on] = [*options[:except_on]].compact
          objects             = [*params].flatten
          object_errors       = []

          objects.each do |object|
            errors = nil
            object = instance_variable_get("@#{object}") if object.is_a?(Symbol)
            object.errors.each do |attr, msg|
              (errors ||= ActiveModel::Errors.new(object)).add(attr, msg) if (options[:on].blank? || options[:on].include?(attr.to_sym)) && (options[:except_on].blank? || !options[:except_on].include?(attr.to_sym))
            end
            object_errors << errors if errors
          end

          unless object_errors.empty?
            options[:class] ||= 'errors'
            options[:id]    ||= objects.map{|object| object.class.name.underscore}.join('-') + '_errors'
            options[:title]   = I18n.t('activerecord.errors.template.header', :model => objects.map{|object| object.class.human}.to_sentence, :count => object_errors.size) if options[:title] === true

            I18n.with_options :locale => options[:locale], :scope => [:activerecord, :errors, :template] do |locale|
              messages = object_errors.sum{|errors| errors.full_messages.map{|msg| '<li>' + ERB::Util.html_escape(msg) + '</li>'}}.join.html_safe
              contents = ''
              contents << '<p class="title">' + options[:title] + '</p>' unless options[:title].blank?
              contents << '<ul class="messages">' + messages + '</ul>'

              "<div id=\"#{options[:id]}\" class=\"#{options[:class]}\">#{contents}</div>".html_safe
            end
          else
            ''
          end
        end

        private ########################################################################################################

        # Get locale from top-level domain or return nil if such locale is not available
        # You have to put something like:
        #   127.0.0.1 application.com
        #   127.0.0.1 application.it
        #   127.0.0.1 application.pl
        # in your /etc/hosts file to try this out locally
        def extract_locale_from_tld
          locale = request.host.split('.').last
          !locale.blank? && I18n.available_locales.include?(locale.to_sym) ? locale  : nil
        end

        # Get locale code from request subdomain (like http://it.application.local:3000)
        # You have to put something like:
        #   127.0.0.1 gr.application.local
        # in your /etc/hosts file to try this out locally
        def extract_locale_from_subdomain
          locale = request.subdomains.first
          !locale.blank? && I18n.available_locales.include?(locale.to_sym) ? locale  : nil
        end

      end

    end
  end
end