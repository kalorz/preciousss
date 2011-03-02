module Preciousss

  class Railtie < Rails::Railtie

    initializer 'preciousss.view_helpers' do |app|
      ActiveSupport.on_load :action_view do
        require 'preciousss/view_helpers/action_view'

        include Preciousss::ViewHelpers::ActionView
      end

      ActiveSupport.on_load :action_controller do
        require 'preciousss/controllers/helpers'

        include Preciousss::Controllers::Helpers
      end
    end

  end

end
